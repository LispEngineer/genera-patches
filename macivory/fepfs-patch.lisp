;;; -*- Mode: LISP; Syntax: Common-Lisp; Package: SYSTEM-INTERNALS; Base: 10; Patch-File: T -*-
;;; Patch file for Private version 0.0
;;; Reason: DEFFEPBLOCK SI:FEPF:  make byte-length be unsigned
;;; Function SI:UNSIGNED-AREF:  actually returned unsigned number
;;; Function SI:FEP-FILE-PROPERTIES-1:  recompile
;;; Written by Reti, 2/28/01 13:31:33
;;; while running on DIS-LOCAL-HOST from FEP0:>In-House-System-447-27.ilod.1
;;; with Experimental System 447.27, Experimental CLOS 433.1, Experimental RPC 437.0,
;;; Experimental Embedding Support 429.1, Experimental MacIvory Support 443.1,
;;; Experimental UX Support 438.0, Experimental Development Utilities 433.0,
;;; Experimental Old TV 431.0, Experimental Zwei 431.4, Experimental Utilities 440.6,
;;; Experimental RPC Development 432.0, Experimental MacIvory Development 430.0,
;;; Experimental UX Development 437.0, Experimental Server Utilities 438.1,
;;; Experimental Serial 431.0, Experimental Hardcopy 441.2, Experimental Zmail 438.0,
;;; Experimental LMFS Defstorage 416.0, Experimental SCSI 427.3,
;;; Experimental Tape 440.0, Experimental LMFS 439.0, Experimental NSage 436.1,
;;; Experimental Extended Help 437.0, Experimental CL Developer 424.0,
;;; Experimental Documentation Database 438.0, Experimental IP-TCP 447.2,
;;; Experimental IP-TCP Documentation 420.0, Experimental CLX 443.0,
;;; Experimental X Remote Screen 441.2, Experimental X Documentation 419.0,
;;; Experimental NFS Client 437.0, Experimental NFS Documentation 421.0,
;;; Experimental Serial Networks 4.3, Experimental Serial Networks Documentation 7.0,
;;; Experimental DNA 435.0, Experimental Metering 440.0,
;;; Experimental Metering Substrate 440.0, Experimental Conversion Tools 432.0,
;;; Experimental Hacks 436.0, Experimental Mac Dex 429.0,
;;; Experimental HyperCard/MacIvory 429.0, Experimental Statice Runtime 461.3,
;;; Experimental Statice 461.1, Experimental Statice Browser 461.0,
;;; Experimental Statice Documentation 424.0, Experimental CLIM 63.19,
;;; Experimental Genera CLIM 63.5, Experimental CLX CLIM 63.1,
;;; Experimental PostScript CLIM 63.1, Experimental CLIM Documentation 63.0,
;;; Experimental CLIM Demo 63.3, Experimental Lock Simple 433.0,
;;; Version Control 404.4, Compare Merge 403.0, VC Documentation 401.0,
;;; Symbolics In-House 439.1, Symbolics In-House Documentation 422.0,
;;; Logical Pathnames Translation Files NEWEST, cold load 1,
;;; Ivory Revision 4A (FPA enabled), FEP 333, FEP0:>i333-loaders.flod(4),
;;; FEP0:>i333-lisp.flod(4), FEP0:>i333-info.flod(4), FEP0:>i333-debug.flod(4),
;;; FEP0:>i333-kernel.fep(4), Boot ROM version 316, Device PROM version 330,
;;; 1067x748 B&W Screen, Machine serial number 741.


(SCT:FILES-PATCHED-IN-THIS-PATCH-FILE 
  "SYS:L-SYS;FEP-STREAM.LISP.302"
  "SYS:L-SYS;FEP-STREAM.LISP.303")


(SCT:NOTE-PRIVATE-PATCH "Fepfs patch")


;========================
(SCT:BEGIN-PATCH-SECTION)
(SCT:PATCH-SECTION-SOURCE-FILE "SYS:L-SYS;FEP-STREAM.LISP.302")
(SCT:PATCH-SECTION-ATTRIBUTES
  "-*- Mode: Lisp; Base: 8;  Package: SYSTEM-INTERNALS; Lowercase: yes -*-")

(deffepblock fepf
  (feph :included 5)
  fepf-owning-directory
  fepf-version
  (fepf-type :string 4)
  (fepf-creation-date :unsigned)
  (fepf-author :string 28.)
  (fepf-name :string 32.)
  (fepf-comment :string 96.)
  (fepf-byte-length :unsigned)
  ((fepf-directory (byte 1 0))
   (fepf-read-only (byte 1 1))
   (fepf-fixed (byte 1 2))
   (fepf-deleted (byte 1 3)))
  fepf-nentries
  ;; 63-437 map entries
  )


;========================
(SCT:BEGIN-PATCH-SECTION)
(SCT:PATCH-SECTION-SOURCE-FILE "SYS:L-SYS;FEP-STREAM.LISP.303")
(SCT:PATCH-SECTION-ATTRIBUTES
  "-*- Mode: Lisp; Base: 8;  Package: SYSTEM-INTERNALS; Lowercase: yes -*-")

(defun unsigned-aref (array index)
  (ldb (byte 32. 0) (aref array index)))

(defun unsigned-aset (val array index)
  (unless (eql val (ldb (byte 32. 0) val))
    (error "won't fit"))
  (aset (sys::%logldb (byte 32. 0) val) array index))

;========================
(SCT:BEGIN-PATCH-SECTION)
(SCT:PATCH-SECTION-SOURCE-FILE "SYS:L-SYS;FEP-STREAM.LISP.303")
(SCT:PATCH-SECTION-ATTRIBUTES
  "-*- Mode: Lisp; Base: 8;  Package: SYSTEM-INTERNALS; Lowercase: yes -*-")

(defun fep-file-properties-1 (file-header)
  `(:creation-date ,(fepf-creation-date file-header)
    :author ,(fepf-author file-header)
    :comment ,(fepf-comment file-header)
    :byte-size 8.
    :length-in-bytes ,(fepf-byte-length file-header)
    :length-in-blocks ,(fep-file-total-data-pages file-header)
    :directory ,(not (zerop (fepf-directory file-header)))
    :deleted ,(not (zerop (fepf-deleted file-header)))
    :dont-delete ,(not (zerop (fepf-read-only file-header)))))

(defun fep-change-file-properties (access-path pathname properties)
  (let* ((entry (or (fep-file-lookup access-path pathname)
		    (error 'fs:fep-file-not-found ':pathname pathname)))
	 (file-header-dpn (fep-directory-entry-file-header-dpn entry)))
    (fep-write-lock access-path
      (using-resource (file-header disk-array)
	(using-resource (disk-event disk-event)
	  (disk-read file-header disk-event file-header-dpn)
	  (check-block-feph file-header "FEPF")
	  (loop for (prop val) on properties by 'cddr
		do (selectq prop
		     (:creation-date
		      (setf (fepf-creation-date file-header) val))
		     (:author
		      (setf (fepf-author file-header) val))
		     (:comment
		      (setf (fepf-comment file-header) val))
		     (:length-in-bytes
		      (setf (fepf-byte-length file-header) val))
		     (:deleted
		      (setf (fepf-deleted file-header) (if val 1 0)))
		     (:dont-delete
		      (setf (fepf-read-only file-header) (if val 1 0)))
		     (otherwise
		      (ferror "Unknown property ~S in ~S"
			prop (si:copy-if-necessary properties)))))
	  (setf (feph-timestamp file-header) (time:get-universal-time))
	  (disk-write file-header disk-event file-header-dpn)
	  (send access-path :decache-entry (send pathname :directory) pathname)
	  t)))))

(defun fep-file-create (access-path pathname
			&aux directory dir-dpn
			(unit (send access-path :unit))
			sequence-number)
  ;; We look for FEPFS running out of room outside of the lock so another process can do some
  ;; cleanup for us.  Note that if we run out of room and reenter, we'll reuse the sequence
  ;; number we got the first time.  This is correct, although it would be no tragedy to grab
  ;; another one.
  (loop named allocation-loop doing
    (condition-case ()
	 (fep-write-lock access-path
	   ;; Sequence number must be allocated first in case of a recursive
	   ;; call to fep-file-create when creating the sequence number file.
	   (when (null sequence-number)
	     (setq sequence-number (send access-path :allocate-sequence-number)))
	   (setq directory (send pathname :raw-directory))
	   (using-resource (dir-block disk-array)
	     (setq dir-dpn (fep-directory-read access-path pathname directory dir-block))
	     (using-resource (dir-page-block disk-array)
	       (using-resource (disk-event disk-event)
		 (let ((dir-page-dpn
			 (catch 'found-room
			   (map-over-fep-file-blocks dir-block unit
						     #'fep-find-free-directory-entry
						     dir-page-block disk-event))))
		   (unless dir-page-dpn
		     ;; Must allocate another directory page
		     (fepfs-modifying-free-blocks (access-path)
		       (setq dir-page-dpn (car (send access-path :allocate-free-blocks 1 pathname)))
		       (let ((new-data-map (fep-file-data-map dir-block unit default-cons-area 2)))
			 ;; Add new entry to the map
			 (let ((index (array-active-length new-data-map)))
			   (incf (fill-pointer new-data-map) 2)
			   (setf (aref new-data-map index) 1)
			   (setf (aref new-data-map (1+ index)) dir-page-dpn))
			 ;; Build new directory page
			 (fill-array dir-page-block nil 0)
			 (setf (feph-id dir-page-block) "FEPD")
			 (setf (feph-header-version dir-page-block) fepd-page-header-version)
			 (setf (feph-npages dir-page-block) 1)
			 (setf (feph-sequence-number dir-page-block) (feph-sequence-number dir-block))
			 (setf (fepd-page-number dir-page-block)
			       (1- (loop for index from 0 by 2 below (array-active-length new-data-map)
					 sum (aref new-data-map index))))
			 (setf (fepd-nentries dir-page-block) 0)
			 ;; Write out the bittable page first, then the directory page, and then header
			 (with-wired-structure disk-event
			   (write-modified-free-blocks access-path disk-event
			     (with-wired-disk-array (dir-page-block)
			       (setf (feph-timestamp dir-page-block) (time:get-universal-time))
			       (disk-write dir-page-block disk-event dir-page-dpn 1 nil)
			       (fep-write-file-data-map
				 new-data-map dir-block dir-dpn disk-event access-path pathname)))))))
		   (fepfs-modifying-free-blocks (access-path)
		     (let (;; Allocate header page
			   (file-dpn (car (send access-path :allocate-free-blocks 1 pathname)))
			   (file-name (string-clip (send pathname :raw-name) 32.))
			   (file-type (string-clip (send pathname :raw-type) 4))
			   (file-version (send pathname :version)))
		       (unless sequence-number
			 (error 'fs:no-more-room :pathname pathname))
		       ;; Make header
		       (using-resource (file-block disk-array)
			 (setf (feph-id file-block) "FEPF")
			 (setf (feph-header-version file-block) feph-header-version)
			 (setf (feph-npages file-block) 1)
			 (setf (feph-sequence-number file-block) sequence-number)
			 (setf (fepf-owning-directory file-block)
			       (feph-sequence-number dir-page-block))
			 (setf (fepf-version file-block) file-version)
			 (setf (fepf-type file-block) file-type)
			 (setf (fepf-name file-block) file-name)
			 (setf (fepf-author file-block) user-id)
			 (setf (fepf-comment file-block) "")
			 (setf (fepf-byte-length file-block) 0)
			 (setf (fepf-directory file-block) 0)
			 (setf (fepf-read-only file-block) 0)
			 (setf (fepf-fixed file-block) 0)
			 (setf (fepf-deleted file-block) 0)
			 (setf (fepf-nentries file-block) 0)
			 (setf (fepf-creation-date file-block) (time:get-universal-time))
			 ;; Make directory entry
			 (let ((index (+ (* (fepd-nentries dir-page-block) fepd-entry-size)
					 fepd-entry-offset)))
			   (incf (fepd-nentries dir-page-block))
			   (setf (fepd-entry-name dir-page-block index) file-name)
			   (setf (fepd-entry-type dir-page-block index) file-type)
			   (setf (fepd-entry-version dir-page-block index) file-version)
			   (setf (fepd-entry-dpn dir-page-block index) (ldb %%dpn-page-num file-dpn))
			   ;; Now write out all the modified datastructures.  The
			   ;; order of the writes is critical for reliability in
			   ;; case the system halts before they all complete.
			   ;; However, since user disk will flush any pending
			   ;; transactions if an error occurs, this needn't wait
			   ;; for completion until the end.
			   (with-wired-structure disk-event
			     (with-wired-disk-array (dir-page-block)
			       (with-wired-disk-array (file-block)
				 (write-modified-free-blocks access-path disk-event
				   ;; Write header
				   (setf (feph-timestamp file-block) (time:get-universal-time))
				   (disk-write file-block disk-event file-dpn 1 nil)
				   ;; Write directory page
				   (setf (feph-timestamp dir-page-block) (time:get-universal-time))
				   (disk-write dir-page-block disk-event dir-page-dpn 1 nil)))))
			   (let ((entry (make-fep-directory-entry
					  name file-name type file-type version file-version
					  pathname (send pathname :new-pathname 
							 :raw-name file-name
							 :raw-type file-type
							 :version file-version)
					  file-header-dpn file-dpn
					  read-lock 1
					  write-lock 0)))
			     (send access-path :encache-entry directory entry)
			     (return-from allocation-loop entry)))))))))))
       (fs:fep-no-more-room (signal-proceed-case ((ignore)
						  'fs:fep-no-more-room ':pathname pathname)
			      (:retry-file-error))))))

(defmethod (:init base-disk-stream :before) (plist)
  (let ((of-input-nature (memq (send self :direction)
			       '(:input :block-input :probe :probe-directory nil))))
    (fep-read-lock
      (using-resource (file-header disk-array)
	(using-resource (disk-event disk-event)
	  (disk-read file-header disk-event file-header-dpn)
	  (check-block-feph file-header "FEPF")
	  (when (and (not of-input-nature) (neq (send self ':direction) ':block))
	    (setf (fepf-author file-header) user-id)
	    (setf (fepf-creation-date file-header) (cl:get-universal-time))
	    )
	  (setq flavor:property-list
		`(:creation-date ,(fepf-creation-date file-header)
		  :author ,(fepf-author file-header)
		  :length ,(// (* (fepf-byte-length file-header) 8)
			       (get plist :byte-size))
		  :dont-delete ,(not (zerop (fepf-read-only file-header)))
		  :directory ,(not (zerop (fepf-directory file-header)))
		  . ,flavor:property-list))
	  (when (not of-input-nature)
	    (fep-read-to-write-lock
	      (setf (feph-timestamp file-header) (time:get-universal-time))
	      (disk-write file-header disk-event file-header-dpn))))))))

(defmethod (:truncate base-disk-stream) (&optional  n-blocks
						    &key      (area default-cons-area)
						    &aux      (unit (ldb %%dpn-unit file-header-dpn)))
  ;; Lock the file system, to make sure no interaction from other processes.
  (fep-write-lock file-access-path
    (using-resource (file-header disk-array)
      (using-resource (disk-event disk-event)
	(disk-read file-header disk-event file-header-dpn))
      (check-block-feph file-header "FEPF")
      (unless (zerop (fepf-read-only file-header))
	(ferror "Cannot truncate a read-only file"))
      ;; If no block length specified, truncate to part currently used.
      (unless n-blocks
	(setq n-blocks (ceiling (fepf-byte-length file-header)
				(* disk-sector-data-size32 4.))))
      (if (< n-blocks 0)
	  (ferror "Cannot truncate to a negative number of blocks"))
      (let* ((new-data-map (fep-file-data-map file-header unit area))
	     (length-in-blocks (loop for index from 0 by 2 below
					 (array-active-length new-data-map)
				     sum (aref new-data-map index)))
	     (blocks-to-delete (- length-in-blocks n-blocks))
	     (blocks-to-expunge nil))
	(if (< blocks-to-delete 0)
	    (ferror "File is already shorter than truncate request.~@
                  Current size = ~D., truncation request = ~D."
		    length-in-blocks n-blocks))
	;; Loop thru the different mapping sections of the file, starting at the END of the 
	;; file, discarding or trimming the sections until enough blocks have been discarded.
	(loop for section-index downfrom (- (array-length new-data-map) 2) to 0 by 2
	      for section-count = (aref new-data-map section-index)
	      for section-dpn = (aref new-data-map (1+ section-index))
	      for highest-dpn = (+ section-dpn section-count -1)
	      until ( blocks-to-delete 0)
	      do
	  ;; Either discard the entire chunk from the datamap, or trim the chunk and
	  ;; remember how much we trimmed in SECTION-COUNT.  In either event, adjust
	  ;; BLOCKS-TO-DELETE.
	  (if ( blocks-to-delete section-count)
	      (decf (fill-pointer new-data-map) 2)
	      (setf (aref new-data-map section-index) (- section-count blocks-to-delete))
	      (setf section-count blocks-to-delete))
	  (setq blocks-to-delete (- blocks-to-delete section-count))
	  (push (cons highest-dpn section-count) blocks-to-expunge))
	;; Finally, write out the new data map.  This should be done before writing out
	;; the modified free blocks.
	(using-resource (disk-event disk-event)
	  (send self :write-data-map new-data-map disk-event file-header)
	  ;; This is the ugly, inefficient part.  Have to send the same message
	  ;; many times, to mark each block free, one at a time.
	  (fepfs-modifying-free-blocks (file-access-path)
	    (loop for (highest-dpn . section-count) in blocks-to-expunge
		  do (loop for i below section-count
			   do (send file-access-path :set-free-block (- highest-dpn i) nil)))
	    (with-wired-structure disk-event
	      (write-modified-free-blocks file-access-path disk-event))))
	new-data-map))))