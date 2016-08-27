;;; -*- Mode: LISP; Syntax: Common-Lisp; Package: USER; Base: 10; Patch-File: T -*-
;;; Patch file for Private version 0.0
;;; Reason: Function NETI:82586-SET-SCB-COMMAND:  don't ferror
;;; Function CLI::82586-ETHERNET-CONTROLLER-INTERRUPT:  ditto
;;; Written by ZiPpY, 8/14/00 10:06:26
;;; while running on Lisp Machine Woodrow Wilson from FEP11:>Server-CL-HTTP-70-16-C-MIT-8-5.ILOD.1
;;; with Genera 8.5, LMFS 442.1, Documentation Database 440.12,
;;; IP-TCP Documentation 422.0, X Remote Screen 448.3, NFS Server 439.0,
;;; Mailer 438.0, Print Spooler 439.0, Domain Name Server 436.0,
;;; Experimental Lock Simple 435.1, Compare Merge 404.0, VC Documentation 401.0,
;;; Logical Pathnames Translation Files NEWEST, Conversion Tools 436.0,
;;; Metering 444.0, Metering Substrate 444.1, Hacks 440.0, CLIM 72.0,
;;; Genera CLIM 72.0, PostScript CLIM 72.0, Experimental CLIM Documentation 71.27,
;;; Statice Runtime 466.1, Statice 466.0, Statice Browser 466.0,
;;; Statice Server 466.2, 8-5-Patches 2.18, MAC 414.0, HTTP Server 70.57,
;;; Showable Procedures 36.3, Binary Tree 34.0, W3 Presentation System 8.1,
;;; CL-HTTP Server Interface 53.0, Experimental Pop3 Server NEWEST,
;;; Experimental Genera 8 5 Patches 1.0, Genera 8 5 System Patches 1.19,
;;; Genera 8 5 Macivory Support Patches 1.0, Genera 8 5 Mailer Patches 1.1,
;;; Genera 8 5 Domain Name Server Patches 1.1, Genera 8 5 Metering Patches 1.0,
;;; Genera 8 5 Statice Runtime Patches 1.0, Genera 8 5 Statice Patches 1.0,
;;; Genera 8 5 Statice Server Patches 1.0, Genera 8 5 Clim Patches 1.0,
;;; Genera 8 5 Genera Clim Patches 1.0, Genera 8 5 Postscript Clim Patches 1.0,
;;; Genera 8 5 Clim Doc Patches 1.0, Genera 8 5 Lock Simple Patches 1.0,
;;; Lambda Information Retrieval System 22.3, Ivory Revision 4 (FPA enabled),
;;; IFEP 333, FEP9:>I333-loaders.flod(4), FEP9:>I333-info.flod(4),
;;; FEP9:>I333-debug.flod(4), FEP9:>I333-lisp.flod(4), FEP9:>I333-kernel.fep(4),
;;; Boot ROM version 318, Device PROM version 330, 1067x748 B&W Screen,
;;; Machine serial number 420,
;;; Add support for Apple's Gestalt and Speech Managers. (from SYS:MAC;MACIVORY-SPEECH-SUPPORT.LISP.1),
;;; Patch TCP hang on close when client drops connection. (from HTTP:LISPM;SERVER;TCP-PATCH-HANG-ON-CLOSE.LISP.10),
;;; Server-Finger patch (from W:>file-server>server-finger.lisp.35),
;;; hack to treat namespace as a partial cache of domain (from W:>hes>fixes>partial-namespace-domain.lisp.5),
;;; Deny some hosts access to some servers. (from W:>naha>patches>host-service-access-control.lisp.4),
;;; Mailer bandaid patch (from W:>reti>mailer-bandaid-patch.lisp.8),
;;; make sure things are flavor reachable-mailer-host (from W:>hes>fixes>yet-another-mailer-bug.lisp.2),
;;; Smtp accept reject patch (from W:>reti>wilson-smtp-accept-reject-patch.lisp.21),
;;; Nfs server patches (from W:>reti>nfs-server-patches.lisp.4),
;;; Tape spec patch (from W:>Reti>tape-spec-patch),
;;; Ansi common lisp as synonym patch (from W:>reti>ansi-common-lisp-as-synonym-patch),
;;; Set dump dates on compare patch (from W:>reti>set-dump-dates-on-compare-patch.lisp.73),
;;; Domain try harder patch (from W:>reti>domain-try-harder-patch.lisp.6),
;;; Find free ephemeral space patch (from W:>reti>find-free-ephemeral-space-patch.lisp.3),
;;; Make native domain host patch (from W:>reti>make-native-domain-host-patch.lisp.2),
;;; Telnet naws patch (from W:>reti>telnet-naws-patch.lisp.9),
;;; Don't force in the mail-x host (from W:>comlink>v-6>lispm>mailer>mailbox-format).


(SCT:FILES-PATCHED-IN-THIS-PATCH-FILE 
  "SYS:NETWORK;82586-ETHERNET-DRIVER.LISP.16")


(SCT:NOTE-PRIVATE-PATCH "New xl ethernet patch")


;========================
(SCT:BEGIN-PATCH-SECTION)
(SCT:PATCH-SECTION-SOURCE-FILE "SYS:NETWORK;82586-ETHERNET-DRIVER.LISP.16")
#+(AND IMACH (NOT VLM))
(SCT:PATCH-SECTION-ATTRIBUTES
  "-*- Mode: LISP; Syntax: Zetalisp; Package: NETWORK-INTERNALS; Base: 10 -*-")

#+(AND IMACH (NOT VLM))

(DEFWIREDFUN 82586-SET-SCB-COMMAND (INTERFACE COMMAND)
  (SYS:%SET-TRAP-MODE SYS:TRAP-MODE-IO)
  (LET ((SCB (82586-EI-SCB INTERFACE)))
    (LOOP REPEAT 20. DOING
      (LOOP REPEAT 20. DOING
	(WHEN (= (82586-SCB-COMMAND-WORD SCB) 0)
	  (SETF (82586-SCB-COMMAND-WORD SCB) (LDB (BYTE 16. 16.) COMMAND))
	  (82586-CHANNEL-ATTENTION INTERFACE)
	  (RETURN-FROM 82586-SET-SCB-COMMAND)))
      ;; Maybe it missed the channel attention
      (82586-CHANNEL-ATTENTION INTERFACE))
    ;; Looks like things are seriously broken, so turn reset the chip
    (82586-RESET-CHIP INTERFACE)
    #+ignore
    (WIRED-FERROR NIL "82586//82596 appears to be hung")))


;========================
(SCT:BEGIN-PATCH-SECTION)
(SCT:PATCH-SECTION-SOURCE-FILE "SYS:NETWORK;82586-ETHERNET-DRIVER.LISP.16")
#+(AND IMACH (NOT VLM))
(SCT:PATCH-SECTION-ATTRIBUTES
  "-*- Mode: LISP; Syntax: Zetalisp; Package: NETWORK-INTERNALS; Base: 10 -*-")

#+(AND IMACH (NOT VLM))

(DEFWIREDFUN CLI::82586-ETHERNET-CONTROLLER-INTERRUPT (&OPTIONAL (UNIT 0))
  (LET ((INTERFACE (SELECTQ UNIT
		     (0 *82586-ETHERNET-INTERFACE-0*)
		     (1 *82586-ETHERNET-INTERFACE-1*)
		     (2 *82586-ETHERNET-INTERFACE-2*))))
    (WHEN INTERFACE
      ;; Figure out who is responsible
      (LET* ((SCB (82586-EI-SCB INTERFACE))
	     (STATUS (82586-SCB-STATUS-WORD SCB)))
	;; Acknowledge the interrupt.
	(82586-SET-SCB-COMMAND INTERFACE
			       (%LOGDPB (%LOGLDB 82586-SCB-STAT STATUS) 82586-SCB-ACK 0))
	(WHEN (AND (CL:LOGTEST STATUS (%LOGDPBS -1 82586-SCB-CX -1 82586-SCB-CNA 0))
		   (NOT (82586-EI-TRANSMITTER-ACTIVE INTERFACE)))
	  (SETF (82586-EI-TRANSMITTER-ACTIVE INTERFACE) T)
	  (CLI::ENQUEUE-INTERRUPT-TASK #'82586-DO-TRANSMIT-WORK INTERFACE 2))
	(WHEN (AND (CL:LOGTEST STATUS (%LOGDPBS -1 82586-SCB-FR -1 82586-SCB-RNR 0))
		   (NOT (82586-EI-RECEIVER-ACTIVE INTERFACE)))
	  (SETF (82586-EI-RECEIVER-ACTIVE INTERFACE) T)
	  (CLI::ENQUEUE-INTERRUPT-TASK #'82586-CHECK-FOR-RECEIVED-PACKETS INTERFACE 2))
	;; Wait for the command to complete, so we know the interrupt has gone away.
	;; We really do have to wait here because otherwise we'll take another
	;; interrupt.  With Sherman's ECO, we could turn off interrupts from the 82586
	;; at this point and queue a task to wait for it to go to 0 (and then turn the
	;; interrupts back on).
	(BLOCK WAIT-FOR-IT-TO-BE-SAFE
	  (LOOP REPEAT 20. DOING
	    (LOOP REPEAT 20. DOING
	      (WHEN (= (82586-SCB-COMMAND-WORD SCB) 0)
		(RETURN-FROM WAIT-FOR-IT-TO-BE-SAFE))
	      ;; Maybe it missed the channel attention
	      (82586-CHANNEL-ATTENTION INTERFACE)))
	  ;; Looks like things are seriously broken, so reset the chip
	  (82586-RESET-CHIP INTERFACE)
	  #+ignore
	  (WIRED-FERROR NIL "82586//82596 appears to be hung"))))))

