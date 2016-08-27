;;; -*- Mode: LISP; Syntax: Common-Lisp; Package: USER; Base: 10; Patch-File: T -*-
;;; Patch file for Private version 0.0
;;; Reason: Function TV:NWATCH-WHO-FUNCTION:  only use two digit year
;;; Written by Reti, 1/01/00 00:14:58
;;; while running on KR's 2nd machine from FEP0:>mit-genera-8-3-who-calls.ilod.1
;;; with Genera 8.3, Logical Pathnames Translation Files NEWEST, HTTP Server 70.22,
;;; Showable Procedures 36.3, Binary Tree 34.0, W3 Presentation System 8.0, C 437.0,
;;; Lexer Runtime 435.0, Lexer Package 435.0, Minimal Lexer Runtime 436.0,
;;; Lalr 1 431.0, Context Free Grammar 436.0, Context Free Grammar Package 436.0,
;;; C Runtime 435.0, Compiler Tools Package 431.0, Compiler Tools Runtime 431.0,
;;; C Packages 433.0, Syntax Editor Runtime 431.0, C Library Headers 431,
;;; Compiler Tools Development 432.0, Compiler Tools Debugger 431.0,
;;; Experimental C Documentation 423.0, Syntax Editor Support 431.0,
;;; LL-1 support system 435.0, Experimental Jpeg Lib 1.0, Images 430.0,
;;; Genera Extensions 15.0, Essential Image Substrate 427.0, Image Substrate 435.0,
;;; X Server 426.0, Ivory Revision 4A (FPA enabled), FEP 333,
;;; FEP0:>I333-loaders.flod(4), FEP0:>I333-debug.flod(4), FEP0:>I333-info.flod(4),
;;; FEP0:>I333-lisp.flod(4), FEP0:>I333-kernel.fep(4), Boot ROM version 316,
;;; Device PROM version 330, 1067x748 B&W Screen, Machine serial number 1136,
;;; Add clos to mx list methods (from W:>Reti>add-clos-to-mx-list-methods.lisp.1),
;;; Its end of line patch (from W:>Reti>its-end-of-line-patch.lisp.3),
;;; Unix inbox from spoofing patch (from W:>Reti>unix-inbox-from-spoofing-patch.lisp.14),
;;; hack to treat namespace as a partial cache of domain (from W:>hes>fixes>partial-namespace-domain.lisp.5),
;;; Popup patch (from W:>Reti>popup-patch.lisp.1),
;;; Content type in forward patch (from W:>Reti>content-type-in-forward-patch.lisp.1),
;;; Attempt to fix recursive block transport (from W:>Reti>rbt-patch.lisp.1),
;;; Directory attributes patch (from W:>Reti>directory-attributes-patch.lisp.6),
;;; Ansi common lisp as synonym patch (from W:>Reti>ansi-common-lisp-as-synonym-patch.lisp.2),
;;; Ivory cdrom patch (from W:>Reti>ivory-cdrom-patch.lisp.6),
;;; Patch TCP hang on close when client drops connection. (from HTTP:LISPM;SERVER;TCP-PATCH-HANG-ON-CLOSE.LISP.10),
;;; Read jfif vogt (from W:>Reti>read-jfif-vogt.lisp.2),
;;; Calendar clock y2k fix (from W:>Reti>calendar-clock-y2k-fix.lisp.4).


(SCT:FILES-PATCHED-IN-THIS-PATCH-FILE 
  "SYS:IO1;TIME.LISP.195"
  "SYS:WINDOW;WHOLIN.LISP.360")


(SCT:NOTE-PRIVATE-PATCH "Genera 8 3 y2k patches")


;========================
(SCT:BEGIN-PATCH-SECTION)
(SCT:PATCH-SECTION-SOURCE-FILE "SYS:IO1;TIME.LISP.195")
(SCT:PATCH-SECTION-ATTRIBUTES
  "-*- Mode:LISP; Package:TIME; Base:8 -*-")

(DEFUN READ-CALENDAR-CLOCK (&OPTIONAL EVEN-IF-BAD)
  (DECLARE (VALUES UT-OR-NIL))
  (MULTIPLE-VALUE-BIND (SECONDS MINUTES HOURS DAY MONTH YEAR DAY-OF-WEEK)
      (PROGN
	#+3600
	(FUNCALL (SELECTQ SYS:*IO-BOARD-TYPE*
		   (:OBS #'SI:READ-CALENDAR-CLOCK-INTERNAL)
		   (:NBS #'CLI::NBS-READ-CALENDAR-CLOCK-INTERNAL))
		 EVEN-IF-BAD)
	#+IMACH
	(SYS:SYSTEM-CASE
	  (Solstice
	    (MULTIPLE-VALUE-BIND (SECONDS MINUTES HOURS DAY MONTH YEAR DAY-OF-WEEK)
		(CLI::SOLSTICE-READ-CALENDAR-CLOCK-INTERNAL)
	      (IF SECONDS
		  (VALUES SECONDS MINUTES HOURS DAY MONTH YEAR DAY-OF-WEEK)
		  (CLI::MERLIN-READ-CALENDAR-CLOCK-INTERNAL EVEN-IF-BAD))))
	  ((Merlin Zora)
	   (CLI::MERLIN-READ-CALENDAR-CLOCK-INTERNAL EVEN-IF-BAD))
	  (MACIVORY
	    (MACINTOSH-INTERNALS::MACIVORY-READ-CALENDAR-CLOCK-INTERNAL))
	  (Domino
	    (CLI::DOMINO-READ-CALENDAR-CLOCK-INTERNAL EVEN-IF-BAD))
	  (OTHERWISE NIL)))
    ;;
    ;; Calendar clock chip only stores 2 digit years.
    ;; This accomodates rollover and will suffice until 2037.
    ;; The 32 bit universal time rolls-over in February of
    ;; that year anyway.  Note that this file is Base 8.
    ;; DRJ, 5/28/99
    ;;
    (WHEN (AND YEAR
	       (<= 00 YEAR 36.))
      (SETQ YEAR (+ 100. YEAR)))    
    DAY-OF-WEEK					;not needed
    (AND SECONDS				;values returned
	 (AND (<= 0 SECONDS 59.)
	      (<= 0 MINUTES 59.)
	      (<= 0 HOURS 23.)
	      (<= 1 MONTH 12.)
	      )
	 (TIME:ENCODE-UNIVERSAL-TIME SECONDS MINUTES HOURS DAY MONTH YEAR 0))))

;========================
(SCT:BEGIN-PATCH-SECTION)
(SCT:PATCH-SECTION-SOURCE-FILE "SYS:WINDOW;WHOLIN.LISP.360")
(SCT:PATCH-SECTION-ATTRIBUTES
  "-*- Syntax: Zetalisp; Mode: LISP; Package: TV; Base: 10; Lowercase: Yes -*-")

;;; Oldstyle :TIME field
;;; Date and time in the who-line, continuously updating.
(defun nwatch-who-function (who-sheet state extra-state)
  (or extra-state
      (let ((default-cons-area who-line-area))
	(setq extra-state (string-append "MM//DD//YY HH:MM:SS"))))
  (let (year month day hours minutes seconds leftx)
    (multiple-value (seconds minutes hours day month year)
      (time:get-time))
    (let ((year (mod year 100.)))
      (cond ((null seconds)			       
	     (send who-sheet :set-cursorpos 0 0)
	     (send who-sheet :clear-rest-of-line)
	     (copy-array-contents "MM//DD//YY HH:MM:SS" extra-state)
	     (values nil extra-state))
	    (t
	     (setq leftx (min (nwatch-n month extra-state 0)
			      (nwatch-n day extra-state 3)
			      (nwatch-n year extra-state 6)
			      (nwatch-n hours extra-state 9)
			      (nwatch-n minutes extra-state 12.)
			      (nwatch-n seconds extra-state 15.)))
	     (when (neq state t) (setq leftx 0))	;was clobbered, redisply all
	     (send who-sheet :set-cursorpos (if (zerop leftx) 0
						(send who-sheet :string-length extra-state
						      0 leftx))
		   0)
	     (send who-sheet :clear-rest-of-line)
	     (send who-sheet :string-out extra-state leftx)
	     (values t extra-state))))))


