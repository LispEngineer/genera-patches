;;;-*-mode: lisp;package: lmfs; base: 8; lowercase:yes; Patch-File: Yes -*-

(defstorage (block-check-words)
  (file-id	      fixnum)
  (word-0s-rel-addr   bit 31.)			;get in low order
  (headerp	      flag))

(defun bitsalv-process-file-buffer (svi fd buf &aux (part (svi-partition)) file-id
				    (array (fb-array buf)))
  ;; Try to psych out whether this guy is really a header.

  (with-fs-locked-for-salvager
    ;; The following macro will downreference the buffer when all is said and done.
    (protect-buffer-addressor (adr (obtain-8bit-addrarray buf))
      (set-word-address-in-addressor adr array 0)	;look at check words
      (when (and (not (zerop (setq file-id (block-check-words-file-id adr))))
		 (zerop (block-check-words-word-0s-rel-addr adr))
		 (block-check-words-headerp adr)
		 (progn (set-word-address-in-addressor
			  adr
			  array
			  (- (partt-record-size-words part)
			     (block-check-words-size-in-words)))
			(= file-id (block-check-words-file-id adr)))
		 (progn (set-word-address-in-addressor
			  adr
			  array
			  (- (partt-block-size-words part)
			     (block-check-words-size-in-words)))
			(= file-id (block-check-words-file-id adr)))
		 ;	     (or (and
		 ;	   (= (block-check-words-word-0s-rel-addr adr)
		 ;     (- (partt-block-size-words part)
		 ;        (* 2 (block-check-words-size-in-words))))))
		 )
	(*catch
	  'file-header-loses
	  (bitsalv-process-file-header svi buf file-id))))
    (salv-free-bufs-for-bogus-file fd)    
    ))

;check is nil to store the check words, t to check them, collect to return a list of them
(defun place-buffer-block-check-words (buf check)
  (fs-ckarg-type buf file-buffer)
  (let ((fd (fb-file-desc buf))
	(r0p (= (fb-lowest-header-addr buf) 0)))
    (if (null fd)
	t						;return as if check case anyway
	(protect-buffer-addressor (adr (obtain-8bit-addrarray
					 (upreference-file-buffer buf)))
	  (let* ((part (fd-partition-desc fd))
		 (block-size-words (partt-block-size-words part))
		 (record-size-blocks (partt-record-size-blocks part))
		 (dataw-per-block (partt-dataw-per-block part))
		 (uid (fd-uid fd))
		 (array (fb-array buf))
		 (result nil))
	    (loop repeat record-size-blocks
		  for buf-offset from 0 by block-size-words
		  and data-addr from (if (> (fb-highest-data-addr+1 buf) (fb-lowest-data-addr buf))
					 (fb-lowest-data-addr buf)
					 -9999999.) by dataw-per-block
		  and hdr-addr from (if (> (fb-highest-header-addr+1 buf) (fb-lowest-header-addr buf))
					(fb-lowest-header-addr buf)
					-9999999.) by dataw-per-block
		  finally (return (or result t))
		  do
		  (let* ((headerp (minusp data-addr))
			 (rel (if headerp hdr-addr data-addr)))
		    (set-word-address-in-addressor adr array buf-offset)
		    (cond ((eq check 'collect)
			   (setq result (nconc result
					       (list* uid
						      (block-check-words-file-id adr)
						      (+ (if headerp 1_31. 0) rel)
						      (+ (if (block-check-words-headerp adr)
							     1_31. 0)
							 (block-check-words-word-0s-rel-addr
							   adr))
						      nil))))
			  (check
			   (if (and *checking-check-words*
				    (check-the-actual-words adr uid headerp rel r0p))
			       (return nil)))
			  (t
			   (setf (block-check-words-headerp adr) headerp)
			   (setf (block-check-words-word-0s-rel-addr adr) rel)
			   (setf (block-check-words-file-id adr) uid)))

		    (set-word-address-in-addressor adr array
						   (- (+ block-size-words buf-offset)
						      (block-check-words-size-in-words)))
		    (cond ((eq check 'collect)
			   (setq result (nconc result
					       (list* uid
						      (block-check-words-file-id adr)
						      (+ (if headerp 1_31. 0) rel)
						      (+ (if (block-check-words-headerp adr)
							     1_31. 0)
							 (block-check-words-word-0s-rel-addr
							   adr))
						      nil))))
			  (check
			   (if (and *checking-check-words*
				    (check-the-actual-words adr uid headerp rel r0p))
			       (return nil)))
			  (t
			   (setf (block-check-words-headerp adr) headerp)
			   (setf (block-check-words-word-0s-rel-addr adr) rel)
			   (setf (block-check-words-file-id adr) uid))))))))))

;;;Check actual check words.  Return Value of T means no-good, they lose. NIL means O.K.
(defun check-the-actual-words (adr uid headerp rel r0p)	;val of t means lose
  (if (null uid)				;root activate
      nil					;it's ok
      (not (and ;; This magic macro avoids bignum consing.
		(block-check-words-compare-file-id adr uid)
		(or r0p
		    (and (eq (block-check-words-headerp adr) headerp)
			 (= (block-check-words-word-0s-rel-addr adr) rel)))))))


#|

(defun write-file-to-bytes (&optional (name "local:>foo.bar") (bytes 100000000))
  (with-open-file (o name :direction :out :element-type'(unsigned-byte 8)
		     :estimated-length bytes)
    (loop with todo = bytes
	  with buf and start and limit
	  do (multiple-value-setq (buf start limit)
				  (send o :get-output-buffer))
	  while buf
	  do (let ((this (min todo (- limit start))))
	       (send o :advance-output-buffer (+ start this))
	       (decf todo this))
	  until (zerop todo))))


|#