;;; -*- Mode: LISP; Syntax: Common-lisp; Package: USER; Base: 10 -*-

#||

Issues:

  Wait function of probe file causes hang

  FEP file errors switching tape block image files get detected by the LMFS as
  dump errors. -- fixed

  Interlocking issues with consumer/producer (locking fep files)

  Multiple zero length files in a row?

  Still errors using input file, need read-input-buffer method. -- fixed

  Handle fep file errors locally (otherwise LMFS skips file and keeps going), especially
   fep file locked. -- fixed and generalized to file errors

  integrate with tape spec, i.e. simulated=<directory-name>

  make simpler output stream using buffered stuff

||#

(defmacro handling-fep-file-errors (&body body)
  `(loop with done and create-errors = 0
	 until done
	 do
     (condition-case (e)
	  (multiple-value-prog1 ,@body 
	    (setq done t))
	(fs::fep-directory-not-found 
	  (if (zerop create-errors)
	      (fs::create-directories-recursively (send e :pathname))
	      (error "Problem creating directory: ~S" e)))
	(fs::fep-file-locked nil)
	(sys::error (si:dbg)))))

(defmacro handling-file-errors (&body body)
  `(loop with done and create-errors = 0
	 until done
	 do
     (condition-case (e)
	  (multiple-value-prog1 ,@body 
	    (setq done t))
	(fs::directory-not-found 
	  (if (zerop create-errors)
	      (fs::create-directories-recursively (send e :pathname))
	      (error "Problem creating directory: ~S" e)))
	(sys::error (format t "~&Got unexpected error ~S" e)
		    (si:dbg)))))

(defvar *automatic-tape-name* nil)
(defvar *automatic-tape-direction* nil)

(defvar *default-chunk-size* (* 5 1024 1024))

(defflavor chunked-file-output-tape
	(
	 (chunk-size *default-chunk-size*)
	 (bytes-written 0)
	 (chunk-counter 0)
	 (name nil)
	 (buffer nil)
	 (character-stream nil)
	 (current-chunk nil)
	 (current-chunk-bytes-written 0)
	 )
      ()
  (:initable-instance-variables chunk-size name)
)

(defflavor chunked-character-output-tape 
	((original-stream))
  (si:output-stream)
  (:initable-instance-variables original-stream)
)

(defmethod (:init chunked-character-output-tape :after) (plist)
  (setq original-stream (si:get plist :original-stream)))

(defmethod (:tape-spec chunked-file-output-tape) (&rest args)
  (format nil "Bogus: chunks")
  )

(defmethod (tape:tape-stream-can-reverse-skip-p chunked-file-output-tape) (&rest args) t)

(defmethod (tape:tape-stream-file-position chunked-file-output-tape) (&rest args)
  bytes-written)

(defmethod (:check-ready chunked-file-output-tape) (&rest args)
  t)

(defmethod (:bot-p chunked-file-output-tape) ()
  (zerop bytes-written))

(defmethod (:unit chunked-file-output-tape) () -1)

(defmethod (:host-name chunked-file-output-tape) () neti:*local-host*)

(defmethod (si:thin-character-stream chunked-file-output-tape) ()
  (if character-stream
      character-stream
      (setq character-stream
	    (make-instance 'chunked-character-output-tape :original-stream self))))


(defmethod (:rewind chunked-file-output-tape) (&rest args)
  (if args
      (si:dbg)
      (if (zerop bytes-written)
	  nil
	  (si:dbg))))

(defmethod (:tyo chunked-file-output-tape) (code)
  (ensure-current-chunk self)
  (handling-file-errors
    (send current-chunk :tyo code))
  (incf bytes-written)
  (incf current-chunk-bytes-written)
  (check-chunk-size self))

(defmethod (check-chunk-size chunked-file-output-tape) (&optional (force? nil))
  (when current-chunk
    (when (or force? (>= current-chunk-bytes-written chunk-size))
      (handling-file-errors
	(close current-chunk))
      (setq current-chunk-bytes-written 0)
      (setq current-chunk nil))))

(defmethod (:string-out chunked-file-output-tape) (array &optional (start 0) limit)
  (unless limit
    (setq limit (length array)))
  (let ((this-time (- limit start)))
    (unless (zerop this-time)
      (ensure-current-chunk self)
      (handling-file-errors
	(send current-chunk :string-out array start limit))
      (incf bytes-written this-time)
      (incf current-chunk-bytes-written this-time)
      (check-chunk-size self))))

(defmethod (:eof chunked-file-output-tape) ()
  (send self :Write-eof))

(defun read-only-file-system-p (pathname)
  (search "CDROM" (format nil "~a" pathname) :test'char-equal))

(defvar *assume-always-free* nil)

(defun free-space (pathname)
  (if *assume-always-free*
      10000000000
  (let ((listing (fs::directory-list pathname)))
    (if (read-only-file-system-p (car (second listing)))
	0
	(let ((info (car listing)))
	  (let ((disk-space-description (si:get info :disk-space-description))
		(bits-per-block (si:get info :block-size)))
	    (if (or (null disk-space-description)
		    (null bits-per-block))
		(error "Can't figure out free space")
		(* bits-per-block
		   (parse-integer disk-space-description :junk-allowed t)))))))))

;;bogus, wait function can't process wait, hence can't call probe-file!
(defun krprocess-wait (state function &rest args)
  (loop until (apply function args)
	do (scl::sleep 1 :sleep-reason state)))

(defvar *continue* t)

(defmethod (advance-chunk-name chunked-file-output-tape) (&aux next-file-name)
  (prog1 (setq next-file-name
	       (format nil "~A~D.tape" name chunk-counter))
	 (krprocess-wait "tape empty" 
			 #'(lambda (size-in-bits)
			     (and *continue*
				  (or (read-only-file-system-p next-file-name)
				  (>= (free-space next-file-name)
				      (* 2 size-in-bits)))))
			 (* 8 chunk-size))
	 (incf chunk-counter)))

(defmethod (ensure-current-chunk chunked-file-output-tape) ()
  (unless current-chunk
    (handling-file-errors
      (setq current-chunk (open (advance-chunk-name self) 
				:estimated-length (* 5 1024 1024)
				:direction :output :element-type'(unsigned-byte 8))))))

(defmethod (:write-eof chunked-file-output-tape) (&optional (n 1))
  (loop repeat n do (check-chunk-size self t)	;close existing
		    (ensure-current-chunk self) ;start new
		    (check-chunk-size self t)	;make zero length 
		    ))

(defmethod (:write-error-status chunked-file-output-tape) (&rest args)
  nil)

(defmethod (:clear-error chunked-file-output-tape) () nil)

(defmethod (:force-output chunked-file-output-tape) () nil)

(defmethod (:close chunked-file-output-tape) (&rest args)
  (check-chunk-size self t))

(defmethod (:skip-file chunked-file-output-tape) (&optional (n 1))
  (if (minusp n)
      nil
      (si:dbg)))

(defmethod (:set-offline chunked-file-output-tape) (&rest args)
  (check-chunk-size self t))

;;Character stream stubs for LMFS dumper's benefit

(defmethod (:tyo chunked-character-output-tape) (char)
  (send original-stream :tyo (char-code char)))

(defmethod (:string-out chunked-character-output-tape) (string &optional (start 0) end)
  (unless end
    (setq end (length string)))
  (stack-let ((binary-array (si:make-array (length string) :type 'si:art-8b
					   :displaced-to string)))
    (send original-stream :string-out binary-array start end)))

(defmethod (:string-in chunked-character-output-tape) (&rest args)
  (signal'sys:end-of-file))


;;Copier to real tape.

(defun copy-to-tape-stream (tape-stream directory &optional (delete nil) n-start process-wait-predicate &rest process-wait-predicate-args)
  (unless (pathnamep directory)
    (setq directory (fs::parse-pathname directory)))
  (loop for n from (or n-start 0)
	for go-ahead = (if process-wait-predicate
			   (process-wait "tape source" #'(lambda ()
							   (apply process-wait-predicate
								  process-wait-predicate-args)))
			   t)
	for entry = (second (fs:directory-list (send directory :new-pathname :name (format nil "~D" n) :type "tape" :version 1)))
	while entry
	  do (if (zerop (si:get entry :length-in-bytes))
		 (send tape-stream :write-eof)
		 (with-open-file (i (first entry) :element-type'(unsigned-byte 8))
		   (loop with buffer and start and limit
			 do (multiple-value-setq (buffer start limit)
			      (send i :read-input-buffer))
			    while buffer
			 do (send tape-stream :string-out buffer start limit)
			    (send i :advance-input-buffer))))
	     (when delete
	       (delete-file (first entry)))
	     finally (return n)))

(defun compare-to-tape-stream (tape-stream directory)
  (loop for n from 0
	for entry = (second (fs:directory-list (send directory :new-pathname :name (format nil "~D" n) :type "tape" :version 1)))
	while entry
	do (if (zerop (si:get entry :length-in-bytes))
	       (send tape-stream :clear-eof)
	       (with-open-file (i (first entry) :element-type'(unsigned-byte 8))
		 (loop for file-byte-count from 0
		       for file-code = (read-byte i nil nil)
		       while file-code
		       for tape-code = (read-byte tape-stream nil nil)
		       unless (eql file-code tape-code)
			 do (format t "~&~A ~D differs: file ~D, tape ~D"
				    (first entry) file-byte-count file-code tape-code))))))

;;Reader of files
(defflavor chunked-file-input-tape
	(
	 (chunk-size (* 5 1024 1024))
	 (bytes-read 0)
	 (chunk-counter 0)
	 (name nil)
	 (buffer nil)
	 (character-stream nil)
	 (current-chunk nil)
	 (current-chunk-bytes-read 0)
	 (at-eof nil)
	 (read-buffer (si:make-array 1024 :type'si:art-8b))
	 (read-buffer-index 0)
	 (read-buffer-limit 1024)
	 )
      ()
  (:initable-instance-variables chunk-size name)
  )

(defmethod (:init chunked-file-input-tape) (plist)
  (let ((name-in-plist (or (si:get plist :name)
			   (and (boundp '*automatic-tape-name*)
				*automatic-tape-name*))))
    (when (null name-in-plist)
      (setq name-in-plist (accept'string :prompt "Directory name")))
    (setq name name-in-plist)))

(defmethod (si:thin-character-stream chunked-file-input-tape) ()
  (if character-stream
      character-stream
      (setq character-stream
	    (make-instance 'chunked-character-input-tape :original-stream self))))

(defmethod (advance-current-chunk chunked-file-input-tape) ()
  (unless at-eof
    (when current-chunk
      (close current-chunk)
      (setq current-chunk nil))
    (ensure-current-chunk self)))

(defmethod (:clear-eof chunked-file-input-tape) ()
  (if at-eof
      (progn
	(setq at-eof nil)
	(advance-current-chunk self))
      (error "clearing eof when not at eof!")))

(defmethod (:skip-file chunked-file-input-tape) (&optional (n 1))
  (when (minusp n)
    (error "backward skip not yet implemented"))
  (loop repeat n
	do (loop for code = (send self :tyi)
		 while code
		 finally (send self :clear-eof))))

(defmethod (:clear-input chunked-file-input-tape) ()
  (when current-chunk
    (send current-chunk :clear-input)))

(defmethod (:tyi chunked-file-input-tape) (&optional eof)
  (ensure-current-chunk self)
  (if at-eof
      nil
      (if (and read-buffer-index
	       (< read-buffer-index read-buffer-limit))
	  (prog1 (aref read-buffer read-buffer-index)
		 (incf read-buffer-index))
	  (multiple-value-bind (index eof-p)
	      (send current-chunk :string-in nil read-buffer 0 (length read-buffer))
	    (if eof-p
		;;here because we've reached end-of-file
		(if (zerop index)
		    (progn
		      (advance-current-chunk self)
		      (if at-eof
			  (progn (setq read-buffer-index nil)
				 (if eof
				     (signal'sys::end-of-file)
				     nil))

			  (send self :tyi)))
		    (si:dbg))
		(progn
		  (setq read-buffer-limit index
			read-buffer-index 0)
		  (send self :tyi)))))))
      
(defmethod (:untyi chunked-file-input-tape) ()
  (if (and read-buffer-index
	   (not (zerop read-buffer-index)))
      (decf read-buffer-index)
      (si:Dbg)))

(defmethod (:listen chunked-file-input-tape) ()
  (si:Dbg))

(defmethod (:read-input-buffer chunked-file-input-tape) (&optional eof no-hang-p)
  (if at-eof
      (si:dbg)
  (if (and read-buffer-index
	   (< read-buffer-index read-buffer-limit))
      (values read-buffer read-buffer-index read-buffer-limit)
      (multiple-value-bind (index eof-p)
	  (send current-chunk :string-in nil read-buffer 0 (length read-buffer))
	(if eof-p
	    (si:dbg)
	    (progn
	      (setq read-buffer-index 0
		    read-buffer-limit index)
	      (values read-buffer read-buffer-index read-buffer-limit)))))))

(defmethod (:advance-input-buffer chunked-file-input-tape) (&optional new-pointer)
  (when (and new-pointer (or (< new-pointer 0)
			     (> new-pointer read-buffer-limit))
	     (error "bad advance")))
  (setq read-buffer-index (or new-pointer read-buffer-limit)))


(defmethod (ensure-current-chunk chunked-file-input-tape) ()
  (unless current-chunk
    (let ((new-name (advance-chunk-name self)))
      ;;keep trying to get next valid chunk
      (loop with done until done 
	    do (if (probe-file new-name)
		   (setq current-chunk (open new-name
					     :direction :input :element-type'(unsigned-byte 8))
			 done t)
		   (cerror "try again" "Chunk ~A not found" new-name)))
    
      (when (zerop (send current-chunk :length))
	(setq at-eof t)))))

(defmethod (:string-in chunked-file-input-tape) (eof string &optional (start 0) end)
  (declare (values index eof-p))
  (ensure-current-chunk self)
  (if at-eof
      (values start t)
      (let* ((finished-early nil)
	     (string-limit (or end (length string)))
	     (string-start (or start 0))
	     (desired-bytes (- string-limit string-start)))
	(loop with to-copy = desired-bytes
	      until (or finished-early (zerop to-copy))
	      do (if (and read-buffer-index
			  (< read-buffer-index read-buffer-limit))
		     (progn
		       (loop for i from read-buffer-index below read-buffer-limit
			     for code = (aref read-buffer i)
			     do (setf (aref string string-start) code)
				(incf string-start)
				(incf read-buffer-index)
				(decf to-copy)
			     until (zerop to-copy)))
		     (progn
		       (multiple-value-bind (index eof-p)
			   (send current-chunk :string-in nil read-buffer 0 (length read-buffer))
			 (setq read-buffer-index 0
			       read-buffer-limit index)
			 (when eof-p
			   (advance-current-chunk self)
			   (when at-eof
			     (setq finished-early string-start
				   read-buffer-index nil)))))))
	(values (or finished-early string-limit) at-eof))))

(defmethod (advance-chunk-name chunked-file-input-tape) ()
  (prog1 (format nil "~A~D.tape" name chunk-counter)
	 (incf chunk-counter)))

(defmethod (:interactive chunked-file-input-tape) ()
  (send current-chunk :interactive))

(defmethod (:close chunked-file-input-tape) (abortp)
  (when current-chunk
    (send current-chunk :close abortp)))

(defmethod (:tape-spec chunked-file-input-tape) (&rest args)
  (format nil "Bogus: chunks from ~A"name)
  )

(defflavor chunked-character-input-tape 
	((original-stream))
  (si:input-stream)
  (:initable-instance-variables original-stream))

(defmethod (:init chunked-character-input-tape :after) (plist)
  (setq original-stream (si:get plist :original-stream)))

(defmethod (:listen chunked-character-input-tape) (&rest args)
  (si:dbg))
(defmethod (:tyi chunked-character-input-tape) (&rest args)
  (let ((code (send original-stream :tyi t)))
    (if (eql code t)
	(si:dbg)
	(code-char code))))

(defmethod (:untyi chunked-character-input-tape) (&rest args)
  (si:dbg))

(defmethod (:line-in chunked-character-input-tape) (&optional (size nil) (eof nil))
  (when (eql size t) (setq size nil))
  (stack-let ((line-buffer (si:Make-array (or size 100) :fill-pointer 0 :type 'si:art-string)))
    (condition-case (e)
	 (loop for code = (send original-stream :tyi t)
	       while code
	       for char = (code-char code)
	       until (char-equal char #\return)
	       do (si:array-push-extend line-buffer char)
	       finally (let ((new (copy-seq line-buffer)))
			 (return new)))
       (sys::end-of-file nil))))


#||

;;here's the form for using a fake stream for input
(scl:letf((#'tape::make-stream #'(lambda (&rest args) (scl::make-instance'user::chunked-file-input-tape))))(lmfs::fsmaint-top-level (scl:send *terminal-io* :superior)))


;;and for output
(scl:letf((#'tape::make-stream #'(lambda (&rest args) (scl:make-instance'user::chunked-file-output-tape))))(lmfs::fsmaint-top-level (scl:send *terminal-io* :superior)))

(defvar *do-expunges* nil)

(loop for number from 0
      for this-file = (format nil "wilson.ai.mit.edu|fep11:>g16494>~d.tape.1" number)
      for next-file = (format nil "wilson.ai.mit.edu|fep11:>g16494>~d.tape.1" (1+ number))
      do (loop until (probe-file next-file) do (sleep 60))
	 (if (zerop (si:Get (fs:file-properties this-file) :length-in-bytes))
	     (send tape :write-eof)
	     #+ignore ;;no good if network error happens in middle of copying to tape
	     (with-open-file (i this-file :element-type'(unsigned-byte 8))
	       (stream-copy-until-eof i tape))
	     (let* ((local-name (gensym))
		    (local-file (format nil "HOST:/docs/reti/~A.tape" local-name)))
	       (loop with done
		     until done
		     do (condition-case (error)
			     (copy-file this-file local-file :characters nil :byte-size 8)
			   (error (format t "~&Couldn't copy because: ~a" error)
				  (sleep 10))
			   (:no-error (setq done t))))
	       (with-open-file (i local-file :element-type'(unsigned-byte 8))
		 (stream-copy-until-eof i tape))
	       (delete-file local-file)))
	 (delete-file this-file)
	 (when *do-expunges*
	   (fs::expunge-directory this-file)))

||#

(defvar *do-expunges* nil)

;;simple-minded single-buffered versions
(defun copy-files-to-tape-stream (output-tape-stream remote-directory 
				  &key (start-number 0) (buffer-size (+ 1024 *default-chunk-size*))
				  (soft-delete? t))
  (stack-let ((buffer (si:make-array buffer-size :type'si:art-8b :fill-pointer 0)))
    (declare (sys::array-register buffer))
    (loop for number from start-number
	  for this-file = (format nil "~a~d.tape.1" remote-directory number)
	  for next-file = (format nil "~a~d.tape.1" remote-directory (1+ number))
	  do (krprocess-wait "File ready"
				    #'(lambda (next-file)
					(ignore-errors (probe-file next-file)))
				    next-file)
	     (loop with done
		   until done
		   for time from 1
		   do (condition-case (error)
			   (progn
			     (setf (fill-pointer buffer) 0)
			     (with-open-file (i this-file :element-type'(unsigned-byte 8))
			       (multiple-value-bind (index eofp)
				   (send i :string-in nil buffer)
			       (unless (eql (fill-pointer buffer) index)
				 (error "huh"))
			       (if eofp
				   (setf done t)
				   (loop for code = (read-byte i nil nil)
					 while code 
					 do (vector-push-extend code buffer)
					 finally (setq done t))))))
			 (error (format t "~&Couldn't read time ~d due to: ~a" time error))))
	     (if (zerop (fill-pointer buffer))
		 (send output-tape-stream :write-eof)
		 (send output-tape-stream :string-out buffer))
	     (when soft-delete?
	       (delete-file this-file)
	       (when *do-expunges*
		 (fs::expunge-directory this-file)))
	     )))

(defun tape-buffer-next-buffer (buffer)
  (array-leader buffer 1))

(defun set-tape-buffer-next-buffer (buffer value)
  (setf (array-leader buffer 1) value))

(defsetf tape-buffer-next-buffer set-tape-buffer-next-buffer)

(defun tape-buffer-filling (buffer)
  (array-leader buffer 2))

(defun set-tape-buffer-filling (buffer value)
  (setf (array-leader buffer 2) value))

(defun (scl::locf tape-buffer-filling) (buffer)
  (locf (array-leader buffer 2)))

(defsetf tape-buffer-filling set-tape-buffer-filling)

(defun tape-buffer-size (buffer)
  (fill-pointer buffer))

(defun set-tape-buffer-size (buffer value)
  (setf (fill-pointer buffer) value))

(defsetf tape-buffer-size set-tape-buffer-size)

(defvar *tape-buffer-area* nil)

(unless *tape-buffer-area*
  (si::make-area :name '*tape-buffer-area*))

(si::defresource tape-buffer (&optional (size 6000000))
  :constructor (si:make-array size :type'si:art-8b :area *tape-buffer-area*
						   :leader-list '(0 nil nil nil))
  :initializer (progn (setf (tape-buffer-size object) 0)
		      (setf (tape-buffer-next-buffer object) nil)
		      (setf (tape-buffer-filling object) nil))
  :deinitializer (progn (setf (tape-buffer-size object) 0)
		      (setf (tape-buffer-next-buffer object) nil)
		      (setf (tape-buffer-filling object) nil)))

(defvar *probe-cache* (make-hash-table :test'equalp))

(defun cached-probe-file (pathname)
  (unless (pathnamep pathname)
    (setq pathname (fs::parse-pathname pathname)))
  (let ((entry (gethash pathname *probe-cache*)))
    (if entry
	entry
	(setf (gethash pathname *probe-cache*) (probe-file pathname)))))

(defvar *header-version* 1)			;format of headered output stream


(defun faster-copy-files-to-tape-stream (output-tape-stream remote-directory 
					 &key (start-number 0) (buffer-size 6000000)
					 (soft-delete? t) (n-buffers 3) (compressed? nil)
					 (headered? nil) (highest-number nil))
  
  (when (and compressed? 
	     (not headered?))
    (cerror "Must be headered to be compressed, need to remember on individual buffer basis"
	    "set headered?")
    (setq headered? t))
  (let ((eofs-written 0))
    (labels ((file-n (n) (format nil "~a~d.tape.1" remote-directory n))
	     (n-complete-p (n)
	       (dbg::when-mode-lock (throw 'exit-because-of-mode-lock nil))
	       (ignore-errors (cached-probe-file (file-n (1+ n)))))
	     (change-id (buffer old new)
	       (let ((pointer (locf (tape-buffer-filling buffer))))
		 (store-conditional pointer old new)))
	     (read-n-into-buffer (buffer n)
	       (unless (null (tape-buffer-filling buffer))
		 (error "Trying to fill already filled buffer"))
	       (unless
		 (change-id buffer nil t)
		 (error "Multiple processes trying to fill?"))
	       (loop with done
		     until done
		     for time from 1
		     do (condition-case (error)
			     (progn
			       (setf (tape-buffer-size buffer) 0)
			       (with-open-file (i (file-n n) :element-type'(unsigned-byte 8))
				 (multiple-value-bind (index eofp)
				     (send i :string-in nil buffer)
				   (unless (eql (tape-buffer-size buffer) index)
				     (error "huh"))
				   (if eofp
				       (progn
					 (unless (change-id buffer t n)
					   (error "T didn't protect!"))
					 (setf done t))
				       #+ignore ;;dumb way
				       (loop for code = (read-byte i nil nil)
					     while code 
					     do ;;relies on buffer being fill-pointered
						(vector-push-extend code buffer)
					     finally (unless (change-id buffer t n)
						       (error "T didn't protect!"))
						     (setq done t))
				       (loop with tbuffer and tstart and tlimit
					     for code = (multiple-value-setq
							  (tbuffer tstart tlimit)
							  (scl::send i :read-input-buffer))
					     while code 
					     do ;;relies on buffer being fill-pointered
						(si::array-push-portion-extend
						  buffer
						  tbuffer tstart tlimit)
						(scl::send i :advance-input-buffer)
					     finally (unless (change-id buffer t n)
						       (error "T didn't protect!"))
						     (setq done t))

))))
			   (error (format t "~&Couldn't read time ~d due to: ~a" time error)))))
	     (ensure-filled (buffer n)
	       (or 
		   (and (eql t (tape-buffer-filling buffer))
			(progn
			  (krprocess-wait (format nil "Fill ~d" n)
					  #'(lambda (buffer)
					      (numberp (tape-buffer-filling buffer)))
					  buffer)
			  (unless (eql (tape-buffer-filling buffer) n)
			    (error "Wrong fill?"))
			  t))
		   (eql (tape-buffer-filling buffer) n)
		   (read-n-into-buffer buffer n)))
	     (possibly-start-filling-more (buffer n)
	       (loop for this-buffer = buffer then (tape-buffer-next-buffer this-buffer)
		     for this-n from n
		     for count from 0
		     repeat (1- n-buffers)
;		   do 
		       #+ignore
		       (format t "~&Considering ~d for ~S: ~a, ~a, ~a"
			       this-n this-buffer 
			       (tape-buffer-size this-buffer)
			       (tape-buffer-next-buffer this-buffer)
			       (tape-buffer-filling this-buffer))
		     when (null (tape-buffer-filling this-buffer))
		       do (when (n-complete-p this-n)
			    (process:process-run-function 
			      (format nil "Fill ~d: ~d" count this-n)
			      #'read-n-into-buffer
			      this-buffer this-n)))))
      (stack-let ((buffers (si:make-array n-buffers)))
	(unwind-protect
	    (progn
	      ;;allocate buffers
	      (loop for i below n-buffers
		    do (setf (aref buffers i)
			     (si:allocate-resource 'tape-buffer buffer-size)))
	      ;;chain and initialize
	      (loop for i below n-buffers
		    for this-buffer = (aref buffers i)
		    for next-buffer = (aref buffers (mod (1+ i) n-buffers))
		    do (setf (tape-buffer-next-buffer this-buffer) next-buffer)
		       (setf (tape-buffer-filling this-buffer) nil))	;empty
	      ;;main loop
	      (catch 'exit-because-of-mode-lock
		(loop with current-buffer = (aref buffers 0)
		      with compressed-buffer = (when compressed?
						 (si:allocate-resource'tape-buffer))
		      with uncompressed-crc and compressed-crc
		      for number from start-number
		      for this-compressed? = compressed?
		      while (or (null highest-number)
				(< number highest-number))
		      do (krprocess-wait "File ready" #'n-complete-p number)
			 (ensure-filled current-buffer number)
			 (possibly-start-filling-more (tape-buffer-next-buffer current-buffer)
						      (1+ number))
			 (unless (tape-buffer-filling current-buffer)
			   (error "Filler didn't mark as full!"))
			 (if (and (not headered?) (zerop (tape-buffer-size current-buffer)))
			     (progn
			       (send output-tape-stream :write-eof)
			       (incf eofs-written)
			       (unless (change-id current-buffer number nil)
				 (error "Null buffer didn't stay marked")))

			     (progn
			       (when compressed?
				 (compress-binary-array current-buffer compressed-buffer)
				 (if (< (length compressed-buffer)
					(length current-buffer))
				     (setq this-compressed? t)
				     (setq this-compressed? nil)))
			       (when headered?
				 (write-begin-header output-tape-stream current-buffer number 
						     this-compressed? 
						     uncompressed-crc
						     compressed-crc))

			       (if this-compressed?
				   (send output-tape-stream :string-out compressed-buffer)
				   (send output-tape-stream :string-out current-buffer))
			       (when headered?
				 (write-end-header output-tape-stream current-buffer number
						   this-compressed? 
						   uncompressed-crc
						   compressed-crc))
			       (unless (change-id current-buffer number nil)
				 (error "Buffer didn't stay marked"))
			       ))
			 (setq current-buffer (tape-buffer-next-buffer current-buffer))
			 #+ignore
			 (format t "~&Wrote ~D" number)
			 (when soft-delete?
			   (delete-file (file-n number))
			   (when *do-expunges*
			     (fs::expunge-directory (file-n number))))))
	      eofs-written)
	  (loop for buffer being the array-elements of buffers
		when buffer
		  do (si:deallocate-resource 'tape-buffer buffer)))))))

(defun skip-till-end (bidirectional-tape-stream)
  (loop with tape = bidirectional-tape-stream and segments = 1
	for code = (condition-case (e) (progn (send tape :skip-file) (send tape :tyi))
		      (sys::error (format t "~&~A" e) nil))
	while code
	do (incf segments)
	finally (send tape :clear-error)
		(return segments)))

(defun highest-number-in-directory (directory)
  (let ((files (directory (cl::make-pathname :defaults directory
					     :name :wild
					     :type "tape"
					     :version :newest))))
    (loop for file in files
	  for name = (cl::pathname-name file)
	  for number = (parse-integer name)
	  maximize number)))

(defun add-to-tape (spec directory &optional (start-number 1) (highest-number nil))
  (when (null highest-number)
    (setq highest-number (highest-number-in-directory directory)))
  (let ((n-segments nil))
    (with-open-stream (tape (tape::make-stream :spec spec :Direction :bidirectional
					       :no-bot-prompt t))
      (send tape :rewind)
      (setq n-segments (skip-till-end tape))
      (faster-copy-files-to-tape-stream tape directory :start-number start-number
					:highest-number highest-number)
      ;;don't want to write a file mark so close with abort
      (close tape :abort t))
    ;;reposition to before added stuff (for compare)
    ;;If you compare backup tape and reply "No" to rewind, you start at new stuff
    (with-open-stream (tape (tape::make-stream :spec spec :Direction :bidirectional
					       :norewind t
					       :no-bot-prompt t))
      (send tape :rewind)
      (send tape :skip-file n-segments))))

(defmacro using-output-disk-tape (tape-name &body body)
  `(let ((*automatic-tape-name* ,tape-name)
	 (*automatic-tape-direction* :output))
     (scl:letf ((#'tape::make-stream
		 #'(lambda (&rest args)
		     (declare (ignore args))
		     (scl::make-instance'user::chunked-file-output-tape :name *automatic-tape-name*)))
		(#'lmfs::identify-mounted-tape 
		 #'(lambda () (list nil :reel *automatic-tape-name*)))
		(#'lmfs::backup-dump-want-to-dump-more-p
		 #'(lambda () nil))
		(#'lmfs::backup-forward-to-end
		 #'(lambda () ())))	;noop
       ,@body)))

(defmacro using-input-disk-tape (tape-name &body body)
  `(let ((*automatic-tape-name* ,tape-name)
	 (*automatic-tape-direction* :input))
     (scl:letf((#'tape::make-stream #'(lambda (&rest args) (declare (ignore args)) (scl::make-instance'user::new-chunked-file-input-tape :name *automatic-tape-name*))))
       ,@body)))


(defun copy-tape-stream-to-files (tape-stream directory)
  (send tape-stream :rewind)
  (copy-tape-stream-to-files-internal tape-stream directory 0 *default-chunk-size*))

(defun copy-tape-stream-to-files-internal (tape-stream directory file-number chunk-size)
  (stack-let ((chunk-buffer (si:make-array chunk-size :type'si:art-8b)))
    (loop with i = file-number
	  with index and eof-p
	  do (multiple-value-setq (index eof-p) (send tape-stream :string-in nil chunk-buffer))
	     (write-chunk i index chunk-buffer directory)
	     (incf i)
	     (when eof-p
	       (write-chunk i 0 chunk-buffer directory)
	       (incf i)
	       (send tape-stream :clear-eof)))))

(defun write-chunk (n limit buffer directory)
  (with-open-file (o (format nil "~a~d.tape" directory n)
		     :direction :output :element-type'(unsigned-byte 8))
    (send o :string-out buffer 0 limit)))


(defun compare-tape-disk (tape disk-name)
  (scl::send tape :rewind)
  (user::using-input-disk-tape disk-name
    (with-open-stream (other (tape::Make-stream))
      (loop with j = -1 and last-i = 0
	    for i from 0
	    for a = (read-byte tape nil nil)
	    for b = (read-byte other nil nil)
;do (format t "~&~D: ~o vs ~O" i a b)
	    unless (Eql a b) do (si:dbg)
	    unless (or a b) do (scl::send tape :clear-eof)
			       (scl::send other :clear-eof)
			       (format t "~&~D: ~D (total ~D)"
				       (incf j) (- i last-i) (setq last-i i ))))))


#|

;;here's the form for using a fake stream for input
(scl:letf((#'tape::make-stream #'(lambda (&rest args) (scl::make-instance'user::new-chunked-file-input-tape))))(lmfs::fsmaint-top-level (scl:send *terminal-io* :superior)))

|#



(defflavor tape-simulation-mixin
	(
	 (chunk-size (* 5 1024 1024))
	 (bytes-read 0)
	 (chunk-counter 0)
	 (name nil)
	 (buffer nil)
	 (character-stream nil)
	 (current-chunk nil)
	 (current-chunk-bytes-read 0)
	 (at-eof nil)
	 (read-buffer (si:make-array 1024 :type'si:art-8b))
	 (read-buffer-index nil)
	 (read-buffer-limit 1024)
	 )
      ()
  (:initable-instance-variables chunk-size name)
  )

(defflavor new-chunked-file-input-tape
	()
	(tape-simulation-mixin si::buffered-input-stream))

(defmethod (:init tape-simulation-mixin) (plist)
  (let ((name-in-plist (or (si:get plist :name)
			   (and (boundp '*automatic-tape-name*)
				*automatic-tape-name*))))
    (when (null name-in-plist)
      (setq name-in-plist (accept'string :prompt "Directory name")))
    (setq name name-in-plist)))

(defmethod (advance-chunk-name tape-simulation-mixin) (&aux next-file-name)
  (prog1 (setq next-file-name
	       (format nil "~A~D.tape" name chunk-counter))
	 (krprocess-wait "tape empty" 
			 #'(lambda (size-in-bits)
			     (and *continue*
				  (or (read-only-file-system-p next-file-name)
				  (>= (free-space next-file-name)
				      (* 2 size-in-bits)))))
			 (* 8 chunk-size))
	 (incf chunk-counter)))

(defmethod (ensure-current-chunk tape-simulation-mixin) ()
  (unless current-chunk
    (let ((new-name (advance-chunk-name self)))
      ;;keep trying to get next valid chunk
      (loop with done until done 
	    do (if (probe-file new-name)
		   (setq current-chunk (open new-name
					     :direction :input :element-type'(unsigned-byte 8))
			 done t)
		   (cerror "try again" "Chunk ~A not found" new-name))))
    (when (zerop (send current-chunk :length))
      (setq at-eof t))))

(defmethod (advance-current-chunk tape-simulation-mixin) ()
  (unless at-eof
    (when current-chunk
      (close current-chunk)
      (setq current-chunk nil))
    (ensure-current-chunk self)))

(defmethod (:clear-eof tape-simulation-mixin) ()
  (if at-eof
      (progn
	(setq at-eof nil)
	(advance-current-chunk self))
      (error "clearing eof when not at eof!")))

(defmethod (:skip-file tape-simulation-mixin) (&optional (n 1))
  (when (minusp n)
    (error "backward skip not yet implemented"))
  (loop repeat n
	do (loop for code = (send self :tyi)
		 while code
		 finally (send self :clear-eof))))

(defmethod (:clear-input tape-simulation-mixin) ()
  (when current-chunk
    (send current-chunk :clear-input)))

(defmethod (:input-wait tape-simulation-mixin) (&optional whostate function &rest arguments)
  nil)

(defmethod (:next-input-buffer tape-simulation-mixin) (&optional no-hang-p)
  (if at-eof
      (values nil nil nil at-eof)
      (progn 
	(ensure-current-chunk self)
	(unless (and read-buffer-index
		     (< read-buffer-index read-buffer-limit))
	  (multiple-value-bind (index eof-p)
	      (send current-chunk :string-in nil read-buffer 0 (length read-buffer))
	    (setq read-buffer-index 0
		  read-buffer-limit index)
	    (when (and eof-p (zerop index))
	      (advance-current-chunk self))))
	(values read-buffer read-buffer-index read-buffer-limit at-eof))))

(defmethod (:discard-input-buffer tape-simulation-mixin) (buffer)
  (setq read-buffer-index nil))

(defmethod (:close tape-simulation-mixin) (abortp)
  (when current-chunk
    (send current-chunk :close abortp)))

(defmethod (si:thin-character-stream tape-simulation-mixin) ()
  (if character-stream
      character-stream
      (setq character-stream
	    (make-instance 'chunked-character-input-tape :original-stream self))))

