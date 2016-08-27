;;; -*- Mode: LISP; Syntax: Common-Lisp; Package: USER; Base: 10; Patch-File: T -*-
;;; Patch file for Private version 0.0
;;; Reason: Function (DEFUN-IN-FLAVOR TCP::FTP-SERVER-PATHNAME TCP::TCP-FTP-SERVER):  if pathname has colon, do full parse
;;; Written by reti, 6/06/07 19:50:16
;;; while running on Fuji-3 from FUJI:/usr/lib/symbolics/kr2.vlod
;;; with Open Genera 2.0, Genera 8.5, Lock Simple 437.0, Version Control 405.0,
;;; Compare Merge 404.0, VC Documentation 401.0,
;;; Logical Pathnames Translation Files NEWEST, Metering 444.0,
;;; Metering Substrate 444.1, Conversion Tools 436.0, Hacks 440.0, CLIM 72.0,
;;; Genera CLIM 72.0, CLX CLIM 72.0, PostScript CLIM 72.0, CLIM Demo 72.0,
;;; CLIM Documentation 72.0, Experimental Genera 8 5 Patches 1.0,
;;; Genera 8 5 System Patches 1.41, Genera 8 5 Macivory Support Patches 1.0,
;;; Genera 8 5 Metering Patches 1.0, Genera 8 5 Joshua Patches 1.0,
;;; Genera 8 5 Jericho Patches 1.0, Genera 8 5 Joshua Doc Patches 1.0,
;;; Genera 8 5 Joshua Metering Patches 1.0, Genera 8 5 Statice Runtime Patches 1.0,
;;; Genera 8 5 Statice Patches 1.0, Genera 8 5 Statice Server Patches 1.0,
;;; Genera 8 5 Statice Documentation Patches 1.0, Genera 8 5 Clim Patches 1.3,
;;; Genera 8 5 Genera Clim Patches 1.0, Genera 8 5 Postscript Clim Patches 1.0,
;;; Genera 8 5 Clx Clim Patches 1.0, Genera 8 5 Clim Doc Patches 1.0,
;;; Genera 8 5 Clim Demo Patches 1.0, Genera 8 5 Color Patches 1.1,
;;; Genera 8 5 Images Patches 1.0, Genera 8 5 Color Demo Patches 1.0,
;;; Genera 8 5 Image Substrate Patches 1.0, Genera 8 5 Lock Simple Patches 1.0,
;;; Genera 8 5 Concordia Patches 1.2, Genera 8 5 Concordia Doc Patches 1.0,
;;; Genera 8 5 C Patches 1.0, Genera 8 5 Pascal Patches 1.0,
;;; Genera 8 5 Fortran Patches 1.0, MAC 415.2, MacIvory Support 447.0,
;;; MacIvory Development 434.0, Color 427.1, Graphics Support 431.0,
;;; Genera Extensions 16.0, Essential Image Substrate 433.0,
;;; Color System Documentation 10.0, SGD Book Design 10.0, Color Demo 422.0,
;;; Images 431.2, Image Substrate 440.4, Statice Runtime 466.1, Statice 466.0,
;;; Statice Browser 466.0, Statice Server 466.2, Statice Documentation 426.0,
;;; Symbolics Concordia 444.0, Graphic Editor 440.0, Graphic Editing 441.0,
;;; Bitmap Editor 441.0, Graphic Editing Documentation 432.0, Postscript 436.0,
;;; Concordia Documentation 432.0, Joshua 237.6, Joshua Documentation 216.0,
;;; Joshua Metering 206.0, Jericho 237.0, C 440.0, Lexer Runtime 438.0,
;;; Lexer Package 438.0, Minimal Lexer Runtime 439.0, Lalr 1 434.0,
;;; Context Free Grammar 439.0, Context Free Grammar Package 439.0, C Runtime 438.0,
;;; Compiler Tools Package 434.0, Compiler Tools Runtime 434.0, C Packages 436.0,
;;; Syntax Editor Runtime 434.0, C Library Headers 434,
;;; Compiler Tools Development 435.0, Compiler Tools Debugger 434.0,
;;; C Documentation 426.0, Syntax Editor Support 434.0, LL-1 support system 438.0,
;;; Fortran 434.0, Fortran Runtime 434.0, Fortran Package 434.0, Fortran Doc 427.0,
;;; Pascal 433.0, Pascal Runtime 434.0, Pascal Package 434.0, Pascal Doc 427.0,
;;; HTTP Server 70.211, Showable Procedures 36.3, Binary Tree 34.0,
;;; Experimental W3 Presentation System 8.2, CL-HTTP Server Interface 54.0,
;;; HTTP Proxy Server 6.34, HTTP Client Substrate 4.23,
;;; W4 Constraint-Guide Web Walker 45.14, Experimental Jpeg Lib 1.0,
;;; HTTP Client 51.10, Experimental Alpha AXP OSF VLM 8,
;;; Experimental Alpha AXP Assembler 8.0,
;;; Experimental Alpha AXP Translator Support 8.2,
;;; Experimental Alpha AXP Emulator Support 8.6, Ivory Revision 5, VLM Debugger 329,
;;; Genera program 8.19, DEC OSF/1 V4.0 (Rev. 110),
;;; 1440x1032 24-bit TRUE-COLOR X Screen FUJI:2.0 with 224 Genera fonts (The Olivetti & Oracle Research Laboratory R3323),
;;; Machine serial number -2142637958,
;;; Patch TCP hang on close when client drops connection. (from HTTP:LISPM;SERVER;TCP-PATCH-HANG-ON-CLOSE.LISP.10),
;;; Prevent reset of input buffer on tcp reset by HTTP servers. (from HTTP:LISPM;W4;RECEIVE-TCP-SEGMENT-PATCH.LISP.7),
;;; Make the yp match stuff ignore the source port (from W:>sys>yp-patch.lisp.1),
;;; Templates patch (from W:>reti>templates-patch.lisp.1),
;;; New pcxal mapping (from KRI:KRI;NEW-PCXAL-MAPPING.LISP.3),
;;; Test permit patch (from KRI:KRI;TEST-PERMIT-PATCH.LISP.3),
;;; Add clos to mx list methods (from KRI:KRI;ADD-CLOS-TO-MX-LIST-METHODS.LISP.1),
;;; Telnet naws patch (from KRI:KRI;TELNET-NAWS-PATCH.LISP.9),
;;; Its end of line patch (from KRI:KRI;ITS-END-OF-LINE-PATCH.LISP.3),
;;; Unix inbox from spoofing patch (from KRI:KRI;UNIX-INBOX-FROM-SPOOFING-PATCH.LISP.22),
;;; Popup patch (from KRI:KRI;POPUP-PATCH.LISP.1),
;;; Content type in forward patch (from KRI:KRI;CONTENT-TYPE-IN-FORWARD-PATCH.LISP.4),
;;; Attempt to fix recursive block transport (from KRI:KRI;RBT-PATCH.LISP.1),
;;; Directory attributes patch (from KRI:KRI;DIRECTORY-ATTRIBUTES-PATCH.LISP.8),
;;; Read jfif vogt (from KRI:KRI;READ-JFIF-VOGT.LISP.4),
;;; Domain try harder patch (from KRI:KRI;DOMAIN-TRY-HARDER-PATCH.LISP.6),
;;; Find free ephemeral space patch (from KRI:KRI;FIND-FREE-EPHEMERAL-SPACE-PATCH.LISP.3),
;;; Section name patch (from KRI:KRI;SECTION-NAME-PATCH.LISP.1),
;;; Tape spec patch (from KRI:KRI;TAPE-SPEC-PATCH.LISP.10),
;;; Set dump dates on compare patch (from KRI:KRI;SET-DUMP-DATES-ON-COMPARE-PATCH.LISP.75),
;;; Load file only bin (from KRI:KRI;LOAD-FILE-ONLY-BIN.LISP.1),
;;; Show jpeg pathname (from KRI:KRI;SHOW-JPEG-PATHNAME.LISP.1),
;;; Bullet proof trampoline args (from KRI:KRI;BULLET-PROOF-TRAMPOLINE-ARGS.LISP.1),
;;; More y2k patches (from KRI:KRI;MORE-Y2K-PATCHES.LISP.10),
;;; Vlm disk save patch (from KRI:KRI;VLM-DISK-SAVE-PATCH.LISP.5),
;;; Domain ad host patch (from KRI:KRI;DOMAIN-AD-HOST-PATCH.LISP.21),
;;; Background dns refreshing (from KRI:KRI;BACKGROUND-DNS-REFRESHING.LISP.16),
;;; Cname level patch (from KRI:KRI;CNAME-LEVEL-PATCH.LISP.11),
;;; Truename version in eco (from KRI:KRI;TRUENAME-VERSION-IN-ECO.LISP.1),
;;; Zmail patches (from KRI:KRI;ZMAIL-PATCHES.LISP.1),
;;; Better sectionization (from KRI:KRI;BETTER-SECTIONIZATION.LISP.5),
;;; Compile interval patch (from KRI:KRI;COMPILE-INTERVAL-PATCH.LISP.10),
;;; Stealth syn handling (from KRI:KRI;STEALTH-SYN-HANDLING.LISP.6),
;;; Define condition patch (from KRI:KRI;DEFINE-CONDITION-PATCH.LISP.4),
;;; Real 32b image patch (from KRI:KRI;REAL-32B-IMAGE-PATCH.LISP.17),
;;; More pict fixes (from KRI:KRI;MORE-PICT-FIXES.LISP.2),
;;; Gif fixes (from KRI:KRI;GIF-FIXES.LISP.8),
;;; Flavor as function spec patch (from KRI:KRI;FLAVOR-AS-FUNCTION-SPEC-PATCH.LISP.1),
;;; Show fep files patch (from KRI:KRI;SHOW-FEP-FILES-PATCH.LISP.7),
;;; Better tar translation (from KRI:KRI;BETTER-TAR-TRANSLATION.LISP.3),
;;; Kludge translate logical pathname patch (from KRI:KRI;KLUDGE-TRANSLATE-LOGICAL-PATHNAME-PATCH.LISP.1),
;;; Ftp wildinferiors by hand patch (from KRI:KRI;FTP-WILDINFERIORS-BY-HAND-PATCH.LISP.1),
;;; Random tilde not homedir patch (from KRI:KRI;RANDOM-TILDE-NOT-HOMEDIR-PATCH.LISP.1).


(SCT:FILES-PATCHED-IN-THIS-PATCH-FILE 
  "SYS:IP-TCP;FTP-SERVER.LISP.4025")


(SCT:NOTE-PRIVATE-PATCH "Allow access to fep via ftp")


;========================
(SCT:BEGIN-PATCH-SECTION)
(SCT:PATCH-SECTION-SOURCE-FILE "SYS:IP-TCP;FTP-SERVER.LISP.4025")
(SCT:PATCH-SECTION-ATTRIBUTES
  "-*- Mode: Lisp; Syntax: Common-Lisp; Package: TCP; Base: 10; Lowercase: Yes -*-")

(defun-in-flavor (ftp-server-pathname tcp-ftp-server) (args)
  (if (and (stringp args)
	   (position #\: args :from-end t))
      (fs::parse-pathname args)
      (fs:merge-pathnames (fs:parse-pathname args net:*local-host*) working-dir)))
