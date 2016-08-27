;;; -*- Mode: LISP; Syntax: Common-lisp; Package: USER; Base: 10; Patch-File: T -*-
;;; Patch file for Private version 0.0
;;; Reason: Function SI:RECEIVE-BAND-WITH-RETRY:  do something smart when byte length is zero
;;; Function (FLAVOR:METHOD :CHANGE-PROPERTIES SI:BASE-DISK-STREAM):  replace non-fixnum byte length with zero
;;; Written by reti, 3/08/01 12:20:36
;;; while running on Stony Brook from FEP9:>y2k.ilod.1
;;; with Experimental System 447.50, Experimental CLOS 433.2, Experimental RPC 437.0,
;;; Experimental Embedding Support 429.1, Experimental MacIvory Support 443.3,
;;; Experimental UX Support 438.0, Experimental Development Utilities 433.0,
;;; Experimental Old TV 431.0, Experimental Zwei 431.6, Experimental Utilities 440.7,
;;; Experimental RPC Development 432.1, Experimental MacIvory Development 430.0,
;;; Experimental UX Development 437.0, Experimental Server Utilities 438.1,
;;; Experimental Serial 431.4, Experimental Hardcopy 441.2, Experimental Zmail 438.3,
;;; Experimental LMFS Defstorage 416.0, Experimental SCSI 427.4,
;;; Experimental Tape 440.1, Experimental LMFS 439.1, Experimental NSage 436.1,
;;; Experimental Extended Help 437.0, Experimental CL Developer 424.0,
;;; Experimental Documentation Database 438.52, Experimental IP-TCP 447.5,
;;; Experimental IP-TCP Documentation 420.0, Experimental CLX 443.0,
;;; Experimental X Remote Screen 441.2, Experimental X Documentation 419.0,
;;; Experimental NFS Client 437.0, Experimental NFS Server 436.0,
;;; Experimental NFS Documentation 421.0, Experimental Serial Networks 4.13,
;;; Experimental Serial Networks Documentation 7.0, Experimental DNA 435.0,
;;; Experimental Metering 440.0, Experimental Metering Substrate 440.0,
;;; Experimental Conversion Tools 432.0, Experimental Hacks 436.0,
;;; Experimental Mac Dex 429.0, Experimental HyperCard/MacIvory 429.0,
;;; Experimental Mailer 435.1, Experimental Print Spooler 436.0,
;;; Experimental Domain Name Server 433.0, Experimental Statice Runtime 461.3,
;;; Experimental Statice 461.1, Experimental Statice Browser 461.0,
;;; Experimental Statice Documentation 424.0, Experimental DBFS Utilities 462.0,
;;; Experimental CLIM 63.45, Experimental Genera CLIM 63.15,
;;; Experimental CLX CLIM 63.6, Experimental PostScript CLIM 63.3,
;;; Experimental CLIM Documentation 63.1, Experimental CLIM Demo 63.5,
;;; Experimental Lock Simple 433.0, Version Control 404.4, Compare Merge 403.0,
;;; VC Documentation 401.0, Symbolics In-House 439.1,
;;; Symbolics In-House Documentation 422.0, SCRC 437.0,
;;; Symbolics In-House Server 432.3, SCRC Server 434.2, Weather User 421.0,
;;; Weather Server 420.0, Logical Pathnames Translation Files NEWEST,
;;; HTTP Server 70.88, Showable Procedures 36.3, Binary Tree 34.0,
;;; Experimental W3 Presentation System 8.1, cold load 1,
;;; Ivory Revision 4A (FPA enabled), FEP 333, FEP0:>i333-loaders.flod(4),
;;; FEP0:>i333-lisp.flod(4), FEP0:>i333-info.flod(4), FEP0:>i333-debug.flod(4),
;;; FEP0:>i333-kernel.fep(4), Boot ROM version 316, Device PROM version 330,
;;; 1067x748 B&W Screen, Machine serial number 741,
;;; Patch TCP hang on close when client drops connection. (from HTTP:LISPM;SERVER;TCP-PATCH-HANG-ON-CLOSE.LISP.10),
;;; Ansi common lisp as synonym patch (from S:>reti>ansi-common-lisp-as-synonym-patch.lisp.2),
;;; 8 5 y2k patches (from S:>Reti>genera-8-5-y2k-patches.lisp.1).

;;; Patch file for Private version 0.0
;;; Written by reti, 3/08/01 13:50:33
;;; while running on Stony Brook from FEP9:>y2k.ilod.1
;;; with Experimental System 447.50, Experimental CLOS 433.2, Experimental RPC 437.0,
;;; Experimental Embedding Support 429.1, Experimental MacIvory Support 443.3,
;;; Experimental UX Support 438.0, Experimental Development Utilities 433.0,
;;; Experimental Old TV 431.0, Experimental Zwei 431.6, Experimental Utilities 440.7,
;;; Experimental RPC Development 432.1, Experimental MacIvory Development 430.0,
;;; Experimental UX Development 437.0, Experimental Server Utilities 438.1,
;;; Experimental Serial 431.4, Experimental Hardcopy 441.2, Experimental Zmail 438.3,
;;; Experimental LMFS Defstorage 416.0, Experimental SCSI 427.4,
;;; Experimental Tape 440.1, Experimental LMFS 439.1, Experimental NSage 436.1,
;;; Experimental Extended Help 437.0, Experimental CL Developer 424.0,
;;; Experimental Documentation Database 438.52, Experimental IP-TCP 447.5,
;;; Experimental IP-TCP Documentation 420.0, Experimental CLX 443.0,
;;; Experimental X Remote Screen 441.2, Experimental X Documentation 419.0,
;;; Experimental NFS Client 437.0, Experimental NFS Server 436.0,
;;; Experimental NFS Documentation 421.0, Experimental Serial Networks 4.13,
;;; Experimental Serial Networks Documentation 7.0, Experimental DNA 435.0,
;;; Experimental Metering 440.0, Experimental Metering Substrate 440.0,
;;; Experimental Conversion Tools 432.0, Experimental Hacks 436.0,
;;; Experimental Mac Dex 429.0, Experimental HyperCard/MacIvory 429.0,
;;; Experimental Mailer 435.1, Experimental Print Spooler 436.0,
;;; Experimental Domain Name Server 433.0, Experimental Statice Runtime 461.3,
;;; Experimental Statice 461.1, Experimental Statice Browser 461.0,
;;; Experimental Statice Documentation 424.0, Experimental DBFS Utilities 462.0,
;;; Experimental CLIM 63.45, Experimental Genera CLIM 63.15,
;;; Experimental CLX CLIM 63.6, Experimental PostScript CLIM 63.3,
;;; Experimental CLIM Documentation 63.1, Experimental CLIM Demo 63.5,
;;; Experimental Lock Simple 433.0, Version Control 404.4, Compare Merge 403.0,
;;; VC Documentation 401.0, Symbolics In-House 439.1,
;;; Symbolics In-House Documentation 422.0, SCRC 437.0,
;;; Symbolics In-House Server 432.3, SCRC Server 434.2, Weather User 421.0,
;;; Weather Server 420.0, Logical Pathnames Translation Files NEWEST,
;;; HTTP Server 70.88, Showable Procedures 36.3, Binary Tree 34.0,
;;; Experimental W3 Presentation System 8.1, cold load 1,
;;; Ivory Revision 4A (FPA enabled), FEP 333, FEP0:>i333-loaders.flod(4),
;;; FEP0:>i333-lisp.flod(4), FEP0:>i333-info.flod(4), FEP0:>i333-debug.flod(4),
;;; FEP0:>i333-kernel.fep(4), Boot ROM version 316, Device PROM version 330,
;;; 1067x748 B&W Screen, Machine serial number 741,
;;; Patch TCP hang on close when client drops connection. (from HTTP:LISPM;SERVER;TCP-PATCH-HANG-ON-CLOSE.LISP.10),
;;; Ansi common lisp as synonym patch (from S:>reti>ansi-common-lisp-as-synonym-patch.lisp.2),
;;; 8 5 y2k patches (from S:>Reti>genera-8-5-y2k-patches.lisp.1).



(SCT:NOTE-PRIVATE-PATCH "Copy world patch")


;========================
(SCT:BEGIN-PATCH-SECTION)
; From buffer band.lisp >rel-8-5>sys>l-sys S: (238)
(SCT:PATCH-SECTION-ATTRIBUTES
  "-*- Syntax: Zetalisp;  Mode: LISP; Package: SYSTEM-INTERNALS; Base: 8; Lowercase: T -*-")

(defun receive-band-with-retry (mode stream source-host source-band target-band
				subset-start subset-n-blocks
				&key (automatic nil)
				     (no-band-query nil)
				     (transfer-p t)
				     (checksum-p t)
				     (offer-boot-file-update t)
				     (interactive t)
				     (if-exists ':error)
				&aux remote-plist
				     remote-length-in-bytes remote-length-in-blocks
				)
  (unless (memq mode '(:fast :slow :local))
    (ferror "~S is not a valid mode to receive-band-with-retry" mode))
  (multiple-value (source-band target-band)
    (parse-source-and-target-bands source-band target-band))
  (setq target-band (fs:parse-pathname target-band))
  (when (null subset-start) (setq subset-start 0))
  (when (and (null subset-n-blocks) (fixp subset-start)) (setq subset-n-blocks 1_30.))
  (cl:multiple-value-setq (remote-plist remote-length-in-bytes remote-length-in-blocks)
    (band-transfer-user-get-remote-info stream source-band))
  (when (zerop remote-length-in-bytes)
    (setq remote-length-in-bytes (* remote-length-in-blocks nbytes-per-block)))
  (setq source-band (car remote-plist)) ;get truename
  ;; Compute this from length-in-bytes, in case the file is larger than necessary
  (setq remote-length-in-blocks (sys:ceiling remote-length-in-bytes nbytes-per-block))
  (multiple-value (subset-start subset-n-blocks)
    (adjust-subset-args subset-start subset-n-blocks remote-length-in-blocks))
  (when interactive
    (format t "~&Remote band is ")
    (print-dired-line remote-plist))
  (terpri)
  (cl:multiple-value-setq (target-band if-exists)
    (band-transfer-user-check-local-target-file target-band if-exists interactive))
  (if (or (not interactive) no-band-query
	  (query-band-transfer "receive" "remote" subset-start subset-n-blocks "local"))
      (progn
	(loop doing
	  (block retry
	    (return
	      (with-open-file-case (local-file target-band
					       :direction :block
					       :if-exists if-exists
					       :if-does-not-exist :create
					       :deleted t	;incomplete copy
					       :estimated-length remote-length-in-bytes)
		(fs:no-more-room
		  (disk-save-make-room target-band remote-length-in-blocks nil)
		  (return-from retry nil))
		(:no-error
		  (set-local-file-incomplete-copy local-file source-host source-band
						  remote-length-in-bytes)
		  (setq target-band (send local-file ':truename))
		  ;; make the file exist, so that if we die partway through we don't
		  ;; throw out the results.
		  (close local-file)
		  (setq local-file (open target-band
					 :direction :block
					 :if-exists :overwrite
					 :if-does-not-exist :error
					 :deleted t))
		  (prog (check-what (no-query t) (marked-complete-but-unchecksummed nil))
		     transfer
			(format t "~&")
			(when transfer-p
			  (selectq mode
			    (:fast (fast-receive-band-internal stream local-file
							       subset-start subset-n-blocks
							       interactive))
			    (:slow (slow-receive-band-internal stream local-file
							       subset-start subset-n-blocks
							       remote-length-in-blocks
							       interactive))
			    (:local (local-receive-band-internal source-band local-file
								 subset-start subset-n-blocks
								 interactive))
			    (otherwise (ferror "This can't happen."))))
			(setq transfer-p t)
			(when (or (not checksum-p)
				  (not (memq ':checksum-blocks
					     *band-version-which-operations*)))
			  (go finish))
			;; make the current file exist in the file system.  If it
			;; something goes wrong during checksumming, the file will
			;; not disappear, but will contain a file comment saying it
			;; is unchecksummed.
			(unless marked-complete-but-unchecksummed
			  (set-local-file-unchecksummed local-file source-host source-band)
			  (setq marked-complete-but-unchecksummed t))
			(if (and subset-start (eql subset-start 0)
				 subset-n-blocks (= subset-n-blocks remote-length-in-blocks))
			    (setq check-what ':entire-file)
			    (setq check-what ':transfer))
		     query-checksum
			(when (or no-query (not interactive)
				  (fquery format:y-or-n-p-options
					  "Checksum the ~A? "
					  (cadr (assq check-what
						      '((:transfer "transfer")
							(:entire-file "entire file"))))))
			  (when no-query
			    (when interactive
			      (format t "~&Checksumming the ~A.~%"
				      (cadr (assq check-what
						  '((:transfer "transfer")
						    (:entire-file "entire file"))))))
			    (unless automatic
			      (setq no-query nil)))
			  (when (eq check-what ':entire-file)
			    (setq subset-start 0 subset-n-blocks remote-length-in-blocks))
			  (setq subset-start (if (eq mode ':local)
						 (checksum-local-band-internal source-band
						   local-file subset-start subset-n-blocks)
						 (checksum-band-internal stream local-file
						   subset-start subset-n-blocks))
				subset-n-blocks nil)
			  (when (and interactive (null subset-start))
			    (format t "~&No bad blocks were found.~%"))
			  (when subset-start
			    (when (or (not interactive) no-query
				      (y-or-n-p "Transfer the bad blocks? "))
			      (go transfer))))
			(when (and (eq check-what ':transfer) (not no-query))
			  (setq check-what ':entire-file)
			  (go query-checksum))
		     finish)
		  (update-local-file-properties local-file remote-plist))))))
	(when offer-boot-file-update
	  (query-set-current-world-load target-band))
	(values subset-start t target-band))	        ; t means "did do transfer"
    (values nil nil nil))) ; nil "did not..." in second value


;========================
(SCT:BEGIN-PATCH-SECTION)
; From buffer fep-stream.lisp >rel-8-5>sys>l-sys S: (302)
(SCT:PATCH-SECTION-ATTRIBUTES
  "-*- Mode: Lisp; Base: 8;  Package: SYSTEM-INTERNALS; Lowercase: yes -*-")

(defmethod (:change-properties base-disk-stream) (error-p &rest properties)
  (loop for remaining on properties
	for (prop value) = remaining
	when (and (eql :length-in-bytes prop)
		  (not (fixnump value)))
	  do (format t "~&changing ~d to 0" value)
	     (setf (second remaining) 0))
  (condition-case-if (not error-p) (error)
      (fep-change-file-properties file-access-path pathname properties)
    (fs:file-operation-failure error)
    (:no-error (loop for (indicator property) on properties by #'cddr
		     do (send self :putprop property indicator)))))

