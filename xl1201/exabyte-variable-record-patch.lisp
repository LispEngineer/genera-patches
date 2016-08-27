;;; -*- Mode: LISP; Syntax: Ansi-common-lisp; Package: FCLI; Lowercase: Yes -*-


;; Use this routine to set the block size to "Variable".
;; Use the CP command "SET TAPE BLOCK SIZE" to do this.

(cp:define-command (com-set-tape-block-size :command-table "User")
    ((tape-unit '(integer 0 6) :prompt "Tape unit #"))
   (scsi:with-scsi-port (port tape-unit)
     (let ((command (scsi:make-scsi-mode-sense-command))
	   (sense-data (make-array 12 :element-type '(unsigned-byte 8)))
	   (select-data (make-array 12 :element-type '(unsigned-byte 8))))
       (setf (scsi:scsi-mode-sense-command-operation-code command 0)
	     scsi:%scsi-command-mode-sense)
       (setf (scsi:scsi-mode-sense-command-allocation-length command 0) (length sense-data))
       (scsi:scsi-port-check-status
	 port (scsi:scsi-port-execute-read-command port command sense-data) :ccs-device-p t)
       (dw:accepting-values ()
	 (setf (scsi:scsi-mode-sense-data-buffered-mode select-data 0)
	       (dw:accept '(dw:alist-member :alist (("No" . 0) ("Yes" . 1)))
			  :prompt "Buffered"
			  :default (scsi:scsi-mode-sense-data-buffered-mode sense-data 0)))
	 (setf (scsi:scsi-mode-sense-data-speed select-data 0)
	       (dw:accept '(dw:alist-member :alist (("Default" . 0)))
			  :prompt "Speed"
			  :default (scsi:scsi-mode-sense-data-speed sense-data 0)))
	 (when (= 8 (scsi:scsi-mode-sense-data-block-descriptor-length sense-data 0))
	   (setf (scsi:scsi-mode-sense-data-block-descriptor-length select-data 0) 8)
	   (setf (scsi:scsi-mode-sense-block-descriptor-block-length select-data 4)
		 (dw:accept '((dw:token-or-type (("Variable" . 0))
						(integer (0) *)))
			    :prompt "Block Length"
			    :default (scsi:scsi-mode-sense-block-descriptor-block-length sense-data 4)))
	   (setf (scsi:scsi-mode-sense-block-descriptor-density-code select-data 4)
		 (dw:accept '(dw:alist-member :alist (("Default" . 0)
						      #||
						      ("800 (NRZI)" . 1)
						      ("1600 (PE)" . 2)
						      ("6250 (GCR)" . 3)
						      ("QIC-11" . 4)
						      ("QIC-24" . 5)
						      ("3200 (PE)" . 6)
						      ||#
						      ))
			    :prompt "Density"
			    :default (scsi:scsi-mode-sense-block-descriptor-density-code sense-data 4)))))
       (setf (scsi:scsi-mode-sense-command-operation-code command 0)
	     scsi:%scsi-command-mode-select)
       (setf (scsi:scsi-mode-sense-command-allocation-length command 0) 12)
       (scsi:scsi-port-check-status
	 port (scsi:scsi-port-execute-write-command port command select-data)
	 :ccs-device-p t))))