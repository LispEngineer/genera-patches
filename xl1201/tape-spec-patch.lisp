;;; -*- Mode: LISP; Syntax: Zetalisp; Package: TAPE; Base: 10; Patch-File: T -*-
;;; Patch file for Private version 0.0
;;; Reason: Variable TAPE:*TAPE-SPEC-KEYWORDS*:  new simulation-directory keyword
;;; Variable TAPE:*TAPE-SPEC-VARS*:  ditto
;;; Function (FLAVOR:METHOD :PRINT-SELF TAPE:TAPE-SPEC):  print it out as simdir
;;; Function TAPE:MAKE-STREAM:  handle simulation-directory
;;; Function TAPE:MAKE-TAPE-SPEC:  add new argument
;;; Written by Reti, 10/14/1999 15:57:05
;;; while running on PUB3 from HOST3:/usr/lib/symbolics/level3-pub3.vlod
;;; with Open Genera 2.0, Genera 8.5, Logical Pathnames Translation Files NEWEST,
;;; Lock Simple 437.0, Version Control 405.0, Compare Merge 404.0, CLIM 72.0,
;;; Genera CLIM 72.0, PostScript CLIM 72.0, CLIM Documentation 72.0,
;;; Statice Runtime 466.1, Statice 466.0, Statice Browser 466.0,
;;; Statice Server 466.2, Statice Documentation 426.0, Joshua 237.3,
;;; Joshua Documentation 216.0, Image Substrate 440.4,
;;; Essential Image Substrate 433.0, Mailer 438.0, Showable Procedures 36.3,
;;; Binary Tree 34.0, Working LispM Mailer 8.0, HTTP Server 70.16,
;;; W3 Presentation System 8.0, CL-HTTP Server Interface 53.0,
;;; Symbolics Common Lisp Compatibility 4.0, Comlink Packages 6.0,
;;; Comlink Utilities 10.2, COMLINK Cryptography 2.0, Routing Taxonomy 9.0,
;;; COMLINK Database 11.26, Email Servers 12.0, Comlink Customized LispM Mailer 7.1,
;;; Dynamic Forms 14.4, Communications Linker Server 39.8,
;;; Lambda Information Retrieval System 22.3, Comlink Documentation Utilities 6.0,
;;; White House Publication System 25.36, WH Automatic Categorization System 15.19,
;;; 8-5-Genera-Local-Patches 1.42, 39-COMLINK-Local-Patches 1.15,
;;; Publications-Server-Local-Patches 1.8, C 440.0, Lexer Runtime 438.0,
;;; Lexer Package 438.0, Minimal Lexer Runtime 439.0, Lalr 1 434.0,
;;; Context Free Grammar 439.0, Context Free Grammar Package 439.0, C Runtime 438.0,
;;; Compiler Tools Package 434.0, Compiler Tools Runtime 434.0, C Packages 436.0,
;;; Syntax Editor Runtime 434.0, C Library Headers 434,
;;; Compiler Tools Development 435.0, Compiler Tools Debugger 434.0,
;;; C Documentation 426.0, Syntax Editor Support 434.0, LL-1 support system 438.0,
;;; Images 431.2, Genera Extensions 16.0, Experimental Jpeg Lib 1.0,
;;; Ivory Revision 5, VLM Debugger 329, Genera program 8.16,
;;; DEC OSF/1 V4.0 (Rev. 205),
;;; 1260x932 24-bit TRUE-COLOR X Screen HOST3:0.0 with 224 Genera fonts (DECWINDOWS Digital Equipment Corporation Digital UNIX V4.0 R1),
;;; Machine serial number 573355066,
;;; Local flavor function patch (from EOP:LOCAL-PATCHES;GENERA;8-5;8-5-GENERA-LOCAL-PATCHES-1-1.LISP.1),
;;; Get emb file host patch (from EOP:LOCAL-PATCHES;GENERA;8-5;8-5-GENERA-LOCAL-PATCHES-1-3.LISP.1),
;;; Get mailer home location from namespace (from EOP:LOCAL-PATCHES;GENERA;8-5;8-5-GENERA-LOCAL-PATCHES-1-4.LISP.1),
;;; Consider internet-domain-name when matching names to file hosts (from EOP:LOCAL-PATCHES;GENERA;8-5;8-5-GENERA-LOCAL-PATCHES-1-5.LISP.1),
;;; Parse pathname patch (from EOP:LOCAL-PATCHES;GENERA;8-5;8-5-GENERA-LOCAL-PATCHES-1-6.LISP.1),
;;; Get internal event code patch (from EOP:LOCAL-PATCHES;GENERA;8-5;8-5-GENERA-LOCAL-PATCHES-1-8.LISP.2),
;;; AutoLogin (from EOP:LOCAL-PATCHES;GENERA;8-5;8-5-GENERA-LOCAL-PATCHES-1-9.LISP.3),
;;; Generate an error any time there domain system tries to create a bogus host object for the local host. (from EOP:LOCAL-PATCHES;GENERA;8-5;8-5-GENERA-LOCAL-PATCHES-1-10.LISP.2),
;;; Set Mailer UID variables for current namespace. (from EOP:LOCAL-PATCHES;GENERA;8-5;8-5-GENERA-LOCAL-PATCHES-1-11.LISP.3),
;;; Provide Switch between EOP and MIT sources. (from EOP:LOCAL-PATCHES;GENERA;8-5;8-5-GENERA-LOCAL-PATCHES-1-12.LISP.2),
;;; Make FS:USER-HOMEDIR look in the namespace as one strategy. (from EOP:LOCAL-PATCHES;GENERA;8-5;8-5-GENERA-LOCAL-PATCHES-1-13.LISP.2),
;;; Local uid patch (from EOP:LOCAL-PATCHES;GENERA;8-5;8-5-GENERA-LOCAL-PATCHES-1-14.LISP.2),
;;; Statice log clear patch (from EOP:LOCAL-PATCHES;GENERA;8-5;8-5-GENERA-LOCAL-PATCHES-1-15.LISP.3),
;;; Make compiled-function-spec-p of CLOS class symbol return NIL instead of erring (from EOP:LOCAL-PATCHES;GENERA;8-5;8-5-GENERA-LOCAL-PATCHES-1-16.LISP.2),
;;; Improve mailer host parsing (from EOP:LOCAL-PATCHES;GENERA;8-5;8-5-GENERA-LOCAL-PATCHES-1-17.LISP.2),
;;; Make native domain name host patch (from EOP:LOCAL-PATCHES;GENERA;8-5;8-5-GENERA-LOCAL-PATCHES-1-18.LISP.2),
;;; Domain query cname loop patch (from EOP:LOCAL-PATCHES;GENERA;8-5;8-5-GENERA-LOCAL-PATCHES-1-19.LISP.2),
;;; Increase disk wired wait timeout from 30 to 90 seconds (from DISTRIBUTION|DIS-EMB-HOST:/db/eop.sct/eop/config/mail-server/patches/disk-wait-90-patch.),
;;; Checkpoint command patch (from EOP:LOCAL-PATCHES;GENERA;8-5;8-5-GENERA-LOCAL-PATCHES-1-23.LISP.2),
;;; Domain Fixes (from CML:MAILER;DOMAIN-FIXES.LISP.33),
;;; Don't force in the mail-x host (from CML:MAILER;MAILBOX-FORMAT.LISP.24),
;;; Make Mailer More Robust (from CML:MAILER;MAILER-FIXES.LISP.15),
;;; Patch TCP hang on close when client drops connection. (from HTTP:LISPM;SERVER;TCP-PATCH-HANG-ON-CLOSE.LISP.10),
;;; Add CLIM presentation and text style format directives. (from FV:SCLC;FORMAT.LISP.20),
;;; Fix Statice Lossage (from CML:LISPM;STATICE-PATCH.LISP.3),
;;; Make update schema work on set-value attributes with accessor names (from CML:LISPM;STATICE-SET-VALUED-UPDATE.LISP.1),
;;; COMLINK Mailer Patches. (from CML:LISPM;MAILER-PATCH.LISP.107),
;;; Clim patches (from CML:DYNAMIC-FORMS;CLIM-PATCHES.LISP.48),
;;; Increase disk wired wait timeout from 30 to 900 seconds (from EOP:LOCAL-PATCHES;GENERA;8-5;8-5-GENERA-LOCAL-PATCHES-1-22.LISP.2),
;;; Tcp implementation error intsrumentation patch (from EOP:LOCAL-PATCHES;GENERA;8-5;8-5-GENERA-LOCAL-PATCHES-1-24.LISP.2),
;;; Increase packet buffers patch (from EOP:LOCAL-PATCHES;GENERA;8-5;8-5-GENERA-LOCAL-PATCHES-1-25.LISP.3),
;;; Close tcb patch (from EOP:LOCAL-PATCHES;GENERA;8-5;8-5-GENERA-LOCAL-PATCHES-1-26.LISP.2),
;;; Get output segment patch (from EOP:LOCAL-PATCHES;GENERA;8-5;8-5-GENERA-LOCAL-PATCHES-1-27.LISP.2),
;;; Expansion buffer hack patch (from EOP:LOCAL-PATCHES;GENERA;8-5;8-5-GENERA-LOCAL-PATCHES-1-28.LISP.2),
;;; Nfs directory list fast patch (from EOP:LOCAL-PATCHES;GENERA;8-5;8-5-GENERA-LOCAL-PATCHES-1-29.LISP.2),
;;; Gc report patch (from EOP:LOCAL-PATCHES;GENERA;8-5;8-5-GENERA-LOCAL-PATCHES-1-31.LISP.2),
;;; Pathname patch (from EOP:LOCAL-PATCHES;GENERA;8-5;8-5-GENERA-LOCAL-PATCHES-1-32.LISP.2),
;;; Pathname2 patch (from EOP:LOCAL-PATCHES;GENERA;8-5;8-5-GENERA-LOCAL-PATCHES-1-33.LISP.1),
;;; Fix NFS brain damage. (from EOP:LOCAL-PATCHES;GENERA;8-5;8-5-GENERA-LOCAL-PATCHES-1-34.LISP.3),
;;; Log patch (from EOP:LOCAL-PATCHES;GENERA;8-5;8-5-GENERA-LOCAL-PATCHES-1-35.LISP.2),
;;; Attempt to fix recursive block transport (from EOP:LOCAL-PATCHES;GENERA;8-5;8-5-GENERA-LOCAL-PATCHES-1-40.LISP.1),
;;; Bad rid error patch (from EOP:LOCAL-PATCHES;COMLINK;39;39-COMLINK-LOCAL-PATCHES-1-1.LISP.1),
;;; Copy database patch (from EOP:LOCAL-PATCHES;COMLINK;39;39-COMLINK-LOCAL-PATCHES-1-2.LISP.1),
;;; Cml bulk mail patch (from EOP:LOCAL-PATCHES;COMLINK;39;39-COMLINK-LOCAL-PATCHES-1-6.LISP.1),
;;; Encode integer date patch (from EOP:LOCAL-PATCHES;COMLINK;39;39-COMLINK-LOCAL-PATCHES-1-7.LISP.1),
;;; Fix year 199,
;;; from silly browsers (from EOP:LOCAL-PATCHES;COMLINK;39;39-COMLINK-LOCAL-PATCHES-1-8.LISP.1),
;;; Fix wddi obsolete references (from EOP:LOCAL-PATCHES;COMLINK;39;39-COMLINK-LOCAL-PATCHES-1-9.LISP.1),
;;; Ccc sign document enable services (from EOP:LOCAL-PATCHES;COMLINK;39;39-COMLINK-LOCAL-PATCHES-1-10.LISP.2),
;;; Redirect to WWW.PUB.WHITEHOUSE.GOV (from EOP:PUB;HTTP;REDIRECT-TO-PRIMARY.LISP.12),
;;; Some holiday favorites for Pete (from EOP:LOCAL-PATCHES;PUBLICATIONS;PUBLICATIONS-SERVER-LOCAL-PATCHES-1-4.LISP.4),
;;; Change random host default (from WILSON.AI.MIT.EDU:>Reti>change-random-host-default).


(SCT:FILES-PATCHED-IN-THIS-PATCH-FILE 
  "SYS:LMTAPE;TAPE-HOST.LISP.4047")


(SCT:NOTE-PRIVATE-PATCH "Tape spec patch")


;========================
(SCT:BEGIN-PATCH-SECTION)
(SCT:PATCH-SECTION-SOURCE-FILE "SYS:LMTAPE;TAPE-HOST.LISP.4047")
(SCT:PATCH-SECTION-ATTRIBUTES
  "-*- Mode: LISP; Base: 8; Package: TAPE; Lowercase: Yes -*-")

;;; -*- Mode: LISP; Base: 8; Package: TAPE; Lowercase: Yes -*-

;;;>
;;;> *****************************************************************************************
;;;> ** (c) Copyright 1998-1982 Symbolics, Inc.  All rights reserved.
;;;> ** Portions of font library Copyright (c) 1984 Bitstream, Inc.  All Rights Reserved.
;;;>
;;;>    The software, data, and information contained herein are proprietary to,
;;;> and comprise valuable trade secrets of, Symbolics, Inc., which intends 
;;;> to keep such software, data, and information confidential and to preserve them
;;;> as trade secrets.  They are given in confidence by Symbolics pursuant 
;;;> to a written license agreement, and may be used, copied, transmitted, and stored
;;;> only in accordance with the terms of such license.
;;;> 
;;;> Symbolics, Symbolics 3600, Symbolics 3675, Symbolics 3630, Symbolics 3640,
;;;> Symbolics 3645, Symbolics 3650, Symbolics 3653, Symbolics 3620, Symbolics 3610,
;;;> Zetalisp, Open Genera, Virtual Lisp Machine, VLM, Wheels, Dynamic Windows,
;;;> SmartStore, Semanticue, Frame-Up, Firewall, Document Examiner,
;;;> Delivery Document Examiner, "Your Next Step in Computing", Ivory, MacIvory,
;;;> MacIvory model 1, MacIvory model 2, MacIvory model 3, XL400, XL1200, XL1201,
;;;> Symbolics UX400S, Symbolics UX1200S, NXP1000, Symbolics C, Symbolics Pascal,
;;;> Symbolics Prolog, Symbolics Fortran, CLOE, CLOE Application Generator,
;;;> CLOE Developer, CLOE Runtime, Common Lisp Developer, Symbolics Concordia,
;;;> Joshua, Statice, and Minima are trademarks of Symbolics, Inc.
;;;> 
;;;> Symbolics 3670, Symbolics Common Lisp, Symbolics-Lisp, and Genera are registered
;;;> trademarks of Symbolics, Inc.
;;;>
;;;> GOVERNMENT PURPOSE RIGHTS LEGEND
;;;> 
;;;>      Contract No.: various
;;;>      Contractor Name: Symbolics, Inc.
;;;>      Contractor Address: c/o Ropes & Gray
;;;> 			 One International Place
;;;> 			 Boston, Massachusetts 02110-2624
;;;>      Expiration Date: 2/27/2018
;;;>      
;;;> The Government's rights to use, modify, reproduce, release, perform, display or
;;;> disclose this software are restricted by paragraph (b)(2) of the "Rights in
;;;> Noncommercial Computer Software and Noncommercial Computer Software Documentation"
;;;> contained in the above identified contracts.  No restrictions apply after the
;;;> expiration date shown above.  Any reproduction of the software or portions thereof
;;;> marked with this legend must also reproduce the markings.  Questions regarding
;;;> the Government's rights may be referred to the AS&T Contracts Office of the
;;;> National Reconnaissance Office, Chantilly, Virginia 20151-1715.
;;;> 
;;;>      Symbolics, Inc.
;;;>      c/o Ropes & Gray
;;;>      One International Place
;;;>      Boston, Massachusetts 02110-2624
;;;>      781-937-7655
;;;>
;;;> *****************************************************************************************
;;;>
;;;>
(defconst *tape-spec-keywords*			;an IBM joke
	  '((:host "machine")
	    (:device "dev" "unit")
	    (:reel "volume" "vol")
	    (:density "dens" "den")
	    (:number-of-buffers "buffers" "bufs" "buffs" "n-buffers" "n-bufs" "n-buffs")
	    (:cart-max-bytes-to-write "cart-max-bytes-to-write")
	    ;; You can screw you own programs!
	    (:record-length "length" "len" "reclen" "recsize")
	    (:granularity "gran")
	    (:minimum-record-length "minimum" "minimum-length" "minimum-record" "minrec"
	     "minreclen")
            (:simulation-directory "simdir")
            ))


;========================
(SCT:BEGIN-PATCH-SECTION)
(SCT:PATCH-SECTION-SOURCE-FILE "SYS:LMTAPE;TAPE-HOST.LISP.4047")
(SCT:PATCH-SECTION-ATTRIBUTES
  "-*- Mode: LISP; Base: 8; Package: TAPE; Lowercase: Yes -*-")

(eval-when (compile load eval)

(defvar *tape-spec-vars*
	  '(host device reel density record-length number-of-buffers granularity
		 minimum-record-length
		 cart-max-bytes-to-write simulation-directory))

)

(defmacro iterate-over-tape-spec-vars ((var kwd) &body (form) &environment env)
  (or kwd (setq kwd (gensym)))
  (let ((vars (list var kwd)))
    `(progn . ,(loop for tape-var in *tape-spec-vars*
		     collect (progv vars (list
					   tape-var
					   (or (second
						 (assq tape-var
						       *tape-spec-var-keywords-and-setters*))
					       (intern (get-pname tape-var)
						       pkg-keyword-package)))
			       (eval form env))))))

(eval-when (compile load eval)
  (setq *tape-spec-var-keywords-and-setters*
	(copytree				;get it compact
	  (loop for x in *tape-spec-vars*
		collect (list x
			      (intern (get-pname x) pkg-keyword-package)
			      (intern (string-append "SET-" x) pkg-keyword-package))))))

(defflavor tape-spec
	#.(loop for x in *tape-spec-vars* collect `(,x nil))
	()
  (:gettable-instance-variables)
  (:settable-instance-variables)
  (:initable-instance-variables))




;========================
(SCT:BEGIN-PATCH-SECTION)
(SCT:PATCH-SECTION-SOURCE-FILE "SYS:LMTAPE;TAPE-HOST.LISP.4047")
(SCT:PATCH-SECTION-ATTRIBUTES
  "-*- Mode: LISP; Base: 8; Package: TAPE; Lowercase: Yes -*-")


(defmethod (:print-self tape-spec) (stream ignore slashp)
  (if slashp (format stream "#<TAPE-SPEC for "))
  (when host
    (princ (if (eq host net:local-host)
	       "Local"
	       (send host :name))
	   stream))
  (let ((printed-colon nil))
    (tape-spec-maybe-print-colon device
      (format stream (if (string-search-set *tape-spec-chars-need-quoting* device)
			 "~S" "~A")
	      device))
    (tape-spec-maybe-print-colon reel
      (format stream "reel=")
      (format stream (if (string-search-set *tape-spec-chars-need-quoting* reel)
			 "~S" "~A")
	      reel))
    (tape-spec-maybe-print-colon density
      (format stream "den=~D" density))
    (tape-spec-maybe-print-colon cart-max-bytes-to-write
      (format stream "cart-max-bytes-to-write=~D" cart-max-bytes-to-write))
    (tape-spec-maybe-print-colon number-of-buffers
      (format stream "buffers=~D" number-of-buffers))
    (tape-spec-maybe-print-colon record-length
      (format stream "reclen=~D" record-length))
    (tape-spec-maybe-print-colon granularity
      (format stream "granularity=~D" granularity))
    (tape-spec-maybe-print-colon minimum-record-length
      (format stream "minrec=~D" minimum-record-length))
    (tape-spec-maybe-print-colon simulation-directory
      (format stream "simdir=~a" simulation-directory))
    )	;c/b :FULL, too.
  (if slashp
      (format stream " ~\si:address\>" (%pointer self))))


;========================
(SCT:BEGIN-PATCH-SECTION)
(SCT:PATCH-SECTION-SOURCE-FILE "SYS:LMTAPE;TAPE-HOST.LISP.4047")
(SCT:PATCH-SECTION-ATTRIBUTES
  "-*- Mode: LISP; Base: 8; Package: TAPE; Lowercase: Yes -*-")

(defun make-stream (&key
		    (direction :input)		; :INPUT, :OUTPUT, :BIDIRECTIONAL,
						;although older forms are accepted.

		    spec			;A (coercible to) tape spec.  If given,
						;overrides :host, :unit, :reel,
						;:record-length, :min-r-l-granularity,
						;:min-rec-len., :number-of-buffers, :density.

		    prompt			;String used if prompting necessary.

		    no-bot-prompt		;Normally, we query if tape not at BOT.
						;If this selected, we don't.

;;;            These next 9 parameters are used to produce a default tape spec, if
;;;	       :spec is not given.  If :host is given, we assume, for compatibility,
;;;	       that the program has extracted all this info out of the user, trying
;;;	       to simulate the new tape system, and we don't prompt.

		    host			;Host. :local and "local" are acceptable, too.

		    device			;Drive identifier.  Numbers accepted.
						;NIL/unsupplied = don't care.
		    reel			;String, server may need.  This is
						;:gettable from stream.
		    record-length		;Record length
		    
		    density			;Number, whatever server likes.

		    cart-max-bytes-to-write	;simulate EOT at this point

		    (minimum-record-length nil min-r-l-supplied-p)
						;Pad any smaller than this.
		    minimum-record-length-granularity	;Pad to this boundary.
						;:FULL accepted for this and above
		    number-of-buffers		;Useful to control performance for both
						;kinds of tape.

                    simulation-directory        ;directory for simulated tape files
;;;           End of tape spec parameters.

		    norewind			;Don't rewind when done.
		    
		    no-read-ahead		;Suppress all read-ahead.

		    pad-char			;What char to pad with, dft 0.

		    buffer-size			;Internal, not useful.

		    (input-stream-mode t)	;If NIL, reading gives EOF at each record end

		    lock-reason			;What to say "Tape in use by ~A"...

		    local			;old compatibility

		    unit			;ditto, for device.
		    background			;for server, = "never prompt"

		    &aux other)

  ;; Old compatibility kludges
  (setq device (or device unit))

  (when local
    (if (and host (neq host net:local-host))
	(ferror "Can't be local and remote at once."))
    (setq host net:local-host))

  (setq direction
	(loop for equivalences
		  in '((:input :read :in) (:output :write :out) (:bidirectional :both))
	      when (memq direction equivalences) return (car equivalences)
	      finally (ferror "Unknown direction for tape - ~S" direction)))

  (setq spec
	(if spec
	    (parse-tape-spec spec)
	    (make-tape-spec
	      :density density
	      :host host
	      :device device
	      :cart-max-bytes-to-write cart-max-bytes-to-write
	      :number-of-buffers number-of-buffers
	      :reel reel
	      :record-length record-length
	      :minimum-record-length minimum-record-length
	      :granularity minimum-record-length-granularity)))

  ;;; When to query.
  ;;; If we don't know the host, better query.
  ;;; But if this is local, and there's other than :cart, we'd better query unless
  ;;; we know the device, unless this is the server, where it should err later if
  ;;; ambiguous, rather than prompt.  Maybe use default-condition signallers?

  (when (or (null (send spec :host))
	    (and (eq (send spec :host) net:local-host)
		 (null (send spec :device))
		 (not background)
		 (< 1 (length (find-tape-drives)))))
	     
    (let ((dft (merge-tape-specs spec)))
      (setq spec
	    (scl:accept 'tape-spec :default dft
			:prompt
			(format nil "Type ~:[tape host or spec~;host or spec for ~:*~A~]"
				prompt)))))

  (setq host (send spec :host)
	cart-max-bytes-to-write (send spec :cart-max-bytes-to-write)
	density (or (send spec :density) 1600.)	;Odd place, but....
	device (send spec :device)
	number-of-buffers (send spec :number-of-buffers)
	reel (send spec :reel)
	record-length (or (send spec :record-length) record-length)	;this is odd too
	minimum-record-length
	(or (send spec :minimum-record-length)
	    minimum-record-length
	    (if (not min-r-l-supplied-p)
		(if pad-char
		    :full
		    (min (or record-length buffer-size 64.) 64.))))	;odder yet

	minimum-record-length-granularity (send spec :granularity)
        simulation-directory (send spec :simulation-directory)
        )

  (do ((find-tape-drives t t)) (nil)
    (catch-error-restart-if (eq host net:local-host)
			    (no-tape-here "Look again for a tape drive, then retry tape mount")
      (catch-error-restart (error "Retry tape mount with different host or parameters (menu)")
	(setq *default-tape-spec* spec)
	(return
	  (cond (simulation-directory
                 (cl::ecase 
                   direction
                   (:input (make-instance 'cl-user::new-chunked-file-input-tape
                                          :name simulation-directory))
                   ((:output :bidirectional) (make-instance 'cl-user::chunked-file-output-tape
                                           :name simulation-directory)))
                 )
                ((or (neq host net:local-host)
		     (and *test-server* (not *test-server-recurse-flag*)))
		 (let-globally-if *test-server*	;must be (not *flag*) if we're here...
				  ((*test-server-recurse-flag* t))
		   (lexpr-funcall 'net:invoke-service-on-host :tape host
				  :direction direction :unit device
				  :no-read-ahead no-read-ahead
				  :pad-char pad-char
				  :buffer-size buffer-size :density density
				  :record-length record-length :reel reel
				  :no-bot-prompt no-bot-prompt
				  :norewind norewind
				  :host host
				  :minimum-record-length minimum-record-length
				  :minimum-record-length-granularity
				  minimum-record-length-granularity
				  :cart-max-bytes-to-write
				  (send spec :cart-max-bytes-to-write)
				  (if (memq direction '(:input :bidirectional))
				      (list :input-stream-mode input-stream-mode)))))
		((not (tape-exists-p))
		 (error 'no-tape-here :host net:local-host))
		((null device)
		 (error 'device-not-provided  :host net:local-host))
		#+imach
		((equal device "CART")
		 (tape-drive-make-stream
		   (first (find-tape-drives))
		   :direction direction
		   :no-read-ahead no-read-ahead :pad-char pad-char
		   :input-stream-mode input-stream-mode
		   :record-length record-length :buffer-size buffer-size
		   :norewind norewind :reel reel :no-bot-prompt no-bot-prompt
		   :lock-reason (or lock-reason "local machine")
		   :minimum-record-length minimum-record-length
		   :minimum-record-length-granularity
		   minimum-record-length-granularity
		   :number-of-buffers number-of-buffers
		   :background background
		   :density density
		   :cart-max-bytes-to-write cart-max-bytes-to-write))
		((dolist (tape-drive (find-tape-drives))
		   (when (tape-drive-device-match tape-drive device)
		     (return (tape-drive-make-stream
			       tape-drive
			       :direction direction
			       :no-read-ahead no-read-ahead :pad-char pad-char
			       :input-stream-mode input-stream-mode
			       :record-length record-length :buffer-size buffer-size
			       :norewind norewind :reel reel :no-bot-prompt no-bot-prompt
			       :lock-reason (or lock-reason "local machine")
			       :minimum-record-length minimum-record-length
			       :minimum-record-length-granularity
			       minimum-record-length-granularity
			       :number-of-buffers number-of-buffers
			       :background background
			       :density density
			       :cart-max-bytes-to-write cart-max-bytes-to-write)))))
		(t (error 'no-such-device :device device :host net:local-host)))))
      ;;Placate choose-variable-values
      (setq other host)
      (tv:choose-variable-values
	`(,@(and prompt (list (string-append "For " prompt) ""))	
	  "(Blank = Don't care//any)"
	  (,(locf host) "Host" :assoc
	   ,(let ((hosts (nconc (cl:sort (loop for h in (likely-tape-hosts host)
					       collect (cons (printable-tape-host h) h))
					 #'string-lessp :key #'first)
				(ncons (cons "Other" "Other")))))
	      (or (rassq host hosts) (setq host "Other"))
	      hosts))
	  (,(locf other) "(/"Other/" value of above)" :host-or-local)
	  (,(locf reel) "Reel name" :string-or-nil)
	  (,(locf device) "Tape drive or unit" :string-or-nil)
	  (,(locf density) "Density" :assoc
	   (("6250" . 6250.)
	    ("3200" . 3200.)
	    ("1600" . 1600.)
	    ("800" . 800.) ("556" . 556.) ("200" . 200.)))
	  (,(locf record-length) "Record Length" :decimal-number)
	  )
	:label "Tape parameters"
	:margin-choices
	'("Retry mount" ("Abort program" . ((signal 'abort)))))
      (setf find-tape-drives nil)
      (setq host (if (equal host "Other") other host)))
    (when find-tape-drives 
      (find-tape-drives t))))


;========================
(SCT:BEGIN-PATCH-SECTION)
(SCT:PATCH-SECTION-SOURCE-FILE "SYS:LMTAPE;TAPE-HOST.LISP.4047")
(SCT:PATCH-SECTION-ATTRIBUTES
  "-*- Mode: LISP; Base: 8; Package: TAPE; Lowercase: Yes -*-")

		      
(defun make-tape-spec (&key host device reel density number-of-buffers record-length
		       cart-max-bytes-to-write
                       granularity minimum-record-length simulation-directory)
  (make-instance 'tape-spec
                 ':host (canonicalize-tape-host host t)
                 ':device (canonicalize-tape-device device)
                 ':reel reel
                 ':density density
                 :cart-max-bytes-to-write cart-max-bytes-to-write
                 ':number-of-buffers number-of-buffers
                 ':record-length record-length
                 ':granularity granularity
                 ':minimum-record-length minimum-record-length
                 :simulation-directory simulation-directory))


;========================
(SCT:BEGIN-PATCH-SECTION)
(SCT:PATCH-SECTION-SOURCE-FILE "SYS:LMTAPE;TAPE-HOST.LISP.4047")
(SCT:PATCH-SECTION-ATTRIBUTES
  "-*- Mode: LISP; Base: 8; Package: TAPE; Lowercase: Yes -*-")

(defmethod (:copy tape-spec) (ts2)
  (iterate-over-tape-spec-vars (variable keyword)
    `(setq ,variable (send ts2 ,keyword))))


(defmethod (:merge tape-spec) (ts2)
  (iterate-over-tape-spec-vars (variable keyword)
    `(if (member
	   (setq ,variable
		 (or ,variable (send ts2 ,keyword)))
	   '("" :unspecific))
	 (setq ,variable nil))))

(defmethod (:filter tape-spec) (keywords)
  (iterate-over-tape-spec-vars (variable keyword)
    `(unless (memq ',keyword keywords)
       (setq ,variable nil))))

;========================
(SCT:BEGIN-PATCH-SECTION)
(SCT:PATCH-SECTION-SOURCE-FILE "SYS:LMTAPE;TAPE-HOST.LISP.4047")
(SCT:PATCH-SECTION-ATTRIBUTES
  "-*- Mode: LISP; Base: 8; Package: TAPE; Lowercase: Yes -*-")

(defun default-tape-spec (&key host
			  (device nil device-p)
			  (reel nil reel-p)
			  cart-max-bytes-to-write
			  (density nil density-p)
			  number-of-buffers record-length
			  granularity minimum-record-length simulation-directory spec)

  (if (and reel (stringp reel)) (setq reel (string-trim '(#\SP #\TAB) reel)))
  (if (equal reel "") (setq reel nil))

  (let ((tentative-answer
	  (merge-tape-specs
	    (make-tape-spec
	      ':host host
	      ':device device
	      ':reel reel
	      ':density density
	      ':cart-max-bytes-to-write cart-max-bytes-to-write
	      ':number-of-buffers number-of-buffers
	      ':record-length record-length
	      ':granularity granularity
	      ':minimum-record-length minimum-record-length
	      ':simulation-directory simulation-directory)
	    (let ((against (copy-tape-spec
			     (if spec
				 (merge-tape-specs spec (default-spec))
				 (default-spec)))))
	      (send against :set-simulation-directory nil)
	      against))))

    ;; Try not to carry REEL around, otherwise menus can't set it NIL.
    (if reel-p (send tentative-answer ':set-reel reel))

    ;; If we weren't explicity told about DEVICE and DENSITY, try to derive them from
    ;; the namespace.
    (let ((tentative-host (send tentative-answer ':host)))
      (unless device-p
	(send tentative-answer ':set-device (default-tape-unit-number tentative-host)))
      (unless density-p
	(send tentative-answer ':set-density (default-tape-density tentative-host))))

    tentative-answer))