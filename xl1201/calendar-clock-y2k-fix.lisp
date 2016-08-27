;;; -*- Mode: LISP; Syntax: Common-Lisp; Package: USER; Base: 10; Patch-File: T -*-
;;; Patch file for Private version 0.0
;;; Reason: Calendar clock chip only stores 2 digit years. This accomodates Y2k rollover 
;;; and will suffice until 2037. The 32 bit universal time counter rolls-over in 
;;; February of that year anyway.  
;;; Written by drj, 6/03/99 11:38:08
;;; while running on CENTAURUS from FEP0:>drj-time-test-3.ilod.1
;;; with Genera 8.3, Logical Pathnames Translation Files NEWEST,
;;; Ivory Revision 4A (FPA enabled), FEP 333, FEP0:>I333-loaders.flod(4),
;;; FEP0:>I333-info.flod(4), FEP0:>I333-debug.flod(4), FEP0:>I333-lisp.flod(4),
;;; FEP0:>i333-xl-kernel.fep(4), Boot ROM version 316, Device PROM version 330,
;;; 1024x798 B&W Screen, Machine serial number 332.


(SCT:FILES-PATCHED-IN-THIS-PATCH-FILE 
  "SYS:IO1;TIME.LISP.195")


(SCT:NOTE-PRIVATE-PATCH "Calendar clock y2k fix")


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

