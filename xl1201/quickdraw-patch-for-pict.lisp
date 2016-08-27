;;; -*- Mode: LISP; Syntax: Common-Lisp; Package: USER; Base: 10; Patch-File: T -*-
;;; Patch file for Private version 0.0
;;; Reason: Function (DEFUN-IN-FLAVOR MTB::UPDATE-STYLES MTB::TO-QUICKDRAW-OUTPUT-STREAM):  Don't try to get font info from the Mac 
;;; Function (FLAVOR:METHOD :BASELINE MTB::TO-QUICKDRAW-OUTPUT-STREAM):  Simply return 0 as the baseline.
;;; Written by Sloat, 1/13/92 14:31:21
;;; while running on Dali from FEP0:>Inc-SWW-on-6-2-beta-11-22.ilod.1

;; Other files might also have to get loaded.
;; See the file D,#TD1PsT[Begin using 006 escapes](1 0 (NIL 0) (NIL :BOLD NIL) "CPTFONTCB")"RED:>SLOAT>PP>PICT-FILES-FOR-L-MACHINE.LISP"

0(SYSTEM-INTERNALS:FILES-PATCHED-IN-THIS-PATCH-FILE 
  "SYS:EMBEDDING;MACIVORY;UI;QUICKDRAW.LISP.72")


(NOTE-PRIVATE-PATCH "Modifications to allow a non macIvory to write/read PICT format files.")


;=====================================
(SYSTEM-INTERNALS:BEGIN-PATCH-SECTION)
(SYSTEM-INTERNALS:PATCH-SECTION-SOURCE-FILE "SYS:EMBEDDING;MACIVORY;UI;QUICKDRAW.LISP.72")
(SYSTEM-INTERNALS:PATCH-SECTION-ATTRIBUTES
  "-*- Mode: LISP; Syntax: Common-lisp; Package: MACINTOSH-INTERNALS; Base: 10; Lowercase: Yes -*-")


;;;; Text stuff

;(defun-in-flavor (update-styles to-quickdraw-output-stream) ()
;  (setq merged-current-character-style (si:merge-character-styles current-character-style
;								  default-character-style)
;	current-font (si:get-font display-device-type si:*standard-character-set*
;				  merged-current-character-style)))

(defun-in-flavor (update-styles to-quickdraw-output-stream) ()
  (setq merged-current-character-style (si:merge-character-styles current-character-style
								  default-character-style)
	current-font nil))



;=====================================
(SYSTEM-INTERNALS:BEGIN-PATCH-SECTION)
(SYSTEM-INTERNALS:PATCH-SECTION-SOURCE-FILE "SYS:EMBEDDING;MACIVORY;UI;QUICKDRAW.LISP.72")
(SYSTEM-INTERNALS:PATCH-SECTION-ATTRIBUTES
  "-*- Mode: LISP; Syntax: Common-lisp; Package: MACINTOSH-INTERNALS; Base: 10; Lowercase: Yes -*-")

;(defmethod (:baseline to-quickdraw-output-stream) ()
;  (qd-font-baseline current-font))


(defmethod (:baseline to-quickdraw-output-stream) ()
  0)

