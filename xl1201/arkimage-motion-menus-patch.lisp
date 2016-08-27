;;; -*- Mode: LISP; Syntax: Common-Lisp; Package: USER; Base: 10; Patch-File: T -*-
;;; Patch file for Private version 0.0
;;; Reason: Function (FLAVOR:METHOD :DRAW-FRAME PAINT:IMAGE-OPERATIONS):  Ditto.
;;; Written by sloat, 3/19/93 18:53:00
;;; while running on Salvadore Dali from FEP0:>ArkSuite-Feb-1.ilod.1
;;; with Genera 8.1.1, Logical Pathnames Translation Files NEWEST, IP-TCP 435.4,
;;; Color Demo 419.1, Color 423.2, Graphics Support 428.0, Images 428.0,
;;; Color Editor 421.0, Experimental SGD Genera Redefinitions 1,
;;; SGD Genera 8.1 Redefinitions 2.1, Genera Extensions 13.1,
;;; Essential Image Substrate 418.2, Ivory Color Support 11.0,
;;; Color System Documentation 5.0, SGD Book Design 4.0, FrameThrower 11.14,
;;; FrameThrower XL Interface 11.0, Image Substrate 426.1, Graphics Toolkit 26.13,
;;; Tablet 18.0, Graphics Library 9.1, Bitstream Font Images 10.0,
;;; Bitstream Font Outlines 10.3, Live Window 422.4, Dummy Foreign Messages 9.0,
;;; Experimental iii site 1.0, Experimental Arkimage 9.82, S-Record 71.11,
;;; Abekas Exabyte Support 3.2, Solitaire 3.0, Experimental ArkSuite 1.1,
;;; Ark-Record 4.0, Ark-Record Internals 2.0, Ark-Record User Interface 2.0,
;;; cold load 1, Ivory Revision 4A (FPA enabled), FEP 325,
;;; FEP0:>i325-loaders.flod(8), FEP0:>i325-info.flod(8), FEP0:>i325-debug.flod(8),
;;; FEP0:>i325-lisp.flod(8), FEP0:>i325-kernel.fep(9), Boot ROM version 316,
;;; Device PROM version 325, 640x137 B&W Screen, 640x484 B&W Screen,
;;; 1067x748 B&W Screen, Machine serial number 550,
;;; FrameThrower Microload 96 (from SYS:COLOR;FRAMETHROWER;INITIALIZATION.LISP.173),
;;; fix load and read so they handle compressed streams transparently (from SYS:SITE;III;DECOMPRESS.LISP.1).


(SYSTEM-INTERNALS:FILES-PATCHED-IN-THIS-PATCH-FILE 
  "GRAPHICS:ARKIMAGE;CODE;MOTION-MENUS.LISP.38")


(NOTE-PRIVATE-PATCH "Make Arkimage load large images to canvas work and resolve some Unix related issues.")


;=====================================
(SYSTEM-INTERNALS:BEGIN-PATCH-SECTION)
(SYSTEM-INTERNALS:PATCH-SECTION-SOURCE-FILE "GRAPHICS:ARKIMAGE;CODE;MOTION-MENUS.LISP.38")
(SYSTEM-INTERNALS:PATCH-SECTION-ATTRIBUTES
  "-*- Base: 10; Lowercase: Yes; Mode: Lisp; Package: Paint; Fonts: CPTFONT,CPTFONTB,CPTFONTI; -*-")


D,#TD1PsT[Begin using 006 escapes](1 0 (NIL 0) (NIL :BOLD NIL) "CPTFONTCB");; Note that the changes from 3/23/93  are in BOLD. Text in comments or in Italics should be commented out.

0(defmethod 1(:draw-frame0 1image-operations)0 (canvas frame stencil-visible?)
  (let ((start (send self :start))
	(end (send self :end)))
    stencil-visible?
    (let ((frame-diff (if cycle-count
			  (mod (- frame start) cycle-count)
			  (- frame start))))
      (tv:prepare-sheet (canvas)
	(cond

(2 0 (NIL 0) (NIL :ITALIC NIL) "CPTFONTI")      ;;; --------- Loading Canvas -----------------------------------------
1	  ;; loading canvas from file
0	  ((and (eq load-from :file) (eq operation :load-canvas))	   
	   (let* (
2;		  (new-file (fs:merge-pathnames
;			      (gt:resolve-project project :image)
;			      file-name))
0		  ;; Files on UNIX hosts are case sensitive. Adapt to not cause an automatic downcase in fs:merge-pathnames.
		  1(new-file (send (gt:resolve-project project :image) :new-raw-name file-name ))
0		  (name file-name)
		  (new-file-name
		    (if (zerop frame-increment)
			name
			(gt:increment-frame-string name (// (* frame-increment frame-diff) frame-increment-per) 1)))
		  image)
	     1(setq new-file (send (send (send new-file :new-raw-name new-file-name) :new-type :image) :new-version :newest))
	     (setq image (color:load-image :file new-file :discard-image nil :load-binary nil ))
	     (send canvas :load-image-to-canvas (paint-find-image image))
2;	     (when image
;	       (color:kill-image image))
;	     (color:load-image-file-into-window
;	       new-file canvas :discard-image t
;	       :write-mask (if protect-alpha *overlay-plane-mask* -1))
0	     ))

1	  ;; load canvas from image
0	  ((and (eq load-from :image) (eq operation :load-canvas))
	   (let* ((image-name
		    (if (zerop image-frame-increment)
			image
			(gt:increment-frame-string image (// (* image-frame-increment frame-diff) frame-increment-per) 1))))
	     (when (paint-find-image image-name)
	       ;(if protect-alpha *overlay-plane-mask* -1)
	       (send canvas :load-image-to-canvas (paint-find-image image-name)))))

1	  ;; copy image to image
0	  ((eq operation :copy-image)
	   (let* ((source-image-name
		    (if (zerop image-frame-increment)
			image
			(gt:increment-frame-string image (// (* image-frame-increment frame-diff)
							     frame-increment-per) 1)))
		  (dest-image-name
		    (if (zerop copy-image-increment)
			copy-image
			(gt:increment-frame-string copy-image
						   (// (* copy-image-increment frame-diff)
						       copy-image-increment-per) 1))))
	     (when (paint-find-image source-image-name)
	       (copy-image-to-image (paint-find-image source-image-name)
				    (paint-find-image dest-image-name)))))

1	  ;; load canvas from frame store
	  ;; OR load canvas from s-record since both use read-video
0	  ((and (eq load-from :video) (eq operation :load-canvas))
	   (let* ((seg (gt:find-object clip)))

	     (when (or seg (not clip))

	       (send *scratch-frame-spec* :copy-instance initial-frame)

	       (send *scratch-frame-spec* :increment-frame
		     (// (* frame-increment frame-diff) frame-increment-per) frame-mode)	     
	       (read-VIDEO (send clip-library :device) canvas frame-mode *scratch-frame-spec* seg)
	       )))


2      ;;; --------- Loading Stencil -----------------------------------------
1	  ;; loading stencil from image
2	  ;; from image
0	  ((eq operation :load-stencil)
	   (send canvas :load-stencil-from-image (paint-find-image stencil-image)))

2      ;;; --------- Saving canvas -----------------------------------------
1	  ;; save to unpaint
0	  ((and (eq operation :save-canvas) (eq save-to :unpaint))
	   (with-unpaint-state canvas t
	     (save-rect-for-unpaint canvas source-x source-y
				    (+ source-x source-width -1)
				    (+ source-y source-height -1))))

1	  ;; save canvas to file
0	  ((and (eq save-to :file) (eq operation :save-canvas))
	   (let* (
2;		  (new-file (fs:merge-pathnames
;			      (gt:resolve-project project :image)
;			      file-name))
0		  1(new-file (send (gt:resolve-project project :image) :new-raw-name file-name ))
0		  (name (send new-file :raw-name))
		  (new-file-name
		    (if (zerop frame-increment)
			name
			(gt:increment-frame-string name (// (* frame-increment frame-diff) frame-increment-per) 1)))
		  )
	     1(setq new-file (send (send (send new-file :new-raw-name new-file-name) :new-type :image) :new-version :newest))0     
	     1(send canvas :save-canvas-to-image (or (paint-find-image "!scratch-image!") "!scratch-image!"))
0	     1(send (paint-find-image "!scratch-image!") :set-source-file new-file)
	     (send (paint-find-image "!scratch-image!") :write-files new-file
		   :rle run-length-encode :menu-icons nil )
	     (when (color:find-image (send new-file :raw-name))
	       (color:kill-image (color:find-image (send new-file :raw-name)))
	       )
2;	     (color:save-window canvas :ask nil :print nil :where :file
;				:menu-icons nil :file-types '(:dump)
;				:load-or-save :save :edges :inside
;				:rle run-length-encode
;				:file new-file :discard-image t)
0	     ))

1	  ;; save canvas to image
0	  ((and (eq operation :save-canvas) (eq save-to :image))
	   (let ((image-name
		   (if (zerop image-frame-increment)
		       image
		       (gt:increment-frame-string image (// (* image-frame-increment frame-diff) frame-increment-per) 1))))
	     (set-modified-page-status (send canvas :screen) (send (paint-find-image image-name) :data-array))
	     (send canvas :save-canvas-to-image (or (paint-find-image image-name) image-name))
	     ))

1	  ;; record frames from canvas
	  ;; or save canvas via s-record
0	  ((and (eq save-to :video) (eq operation :save-canvas))
	   (let ((seg (gt:find-object clip)))
	     (when (or seg (not clip))
	       (send *scratch-frame-spec* :copy-instance initial-frame)
	       (send *scratch-frame-spec* :increment-frame
		     (// (* frame-increment frame-diff) frame-increment-per) frame-mode)
	       (remove-menu canvas)
	       (write-video (send clip-library :device) canvas frame-mode *scratch-frame-spec* seg)
	       )))


2      ;;; --------- Saving stencil -----------------------------------------
1	  ;; save stencil to image
0	  ((eq operation :save-stencil)
	   (when (paint-find-image stencil-image)
	     (1set-modified-page-status0 (send canvas :screen) (send (paint-find-image stencil-image) :data-array)))
	   (send canvas :save-stencil-to-image  (or (paint-find-image stencil-image) stencil-image)))

2      ;;; --------- Erase/Reversing -----------------------------------------
1	  ;; erase canvas
0	  ((eq full-screen-operation :erase-canvas)
	   (send canvas :clear-canvas erase-color nil))
1	  ;; erase stencil
0	  ((eq full-screen-operation :erase-stencil)
	   (let ((val (round (* 255 (send erase-stencil-color :red)))))
	     (send canvas :change-stencil-state :erase
		   (combine-rgba  val val val val))))
1	  ;; erase both
0	  ((eq full-screen-operation :erase-both)
	   (send canvas :clear-canvas erase-color nil)
	   (let ((val (round (* 255 (send erase-stencil-color :red)))))
	     (send canvas :change-stencil-state :erase
		   (combine-rgba  val val val val))))
1	  ;; reverse stencil
0	  ((eq full-screen-operation :reverse-stencil)
	   (send canvas :change-stencil-state :reverse))
1	  ;; reverse canvas
0	  ((eq full-screen-operation :reverse-canvas)
	   (ungrid canvas)
	   (send paint:pc :Draw-rectangle (send canvas :width) (send canvas :height) 0 0
		 tv:alu-xor)
2	   ;; reverse stencil again.
0	   (send canvas :change-stencil-state :reverse))
	 
	  1;; reverse0 1both
0	  ((eq full-screen-operation :reverse-both)
	   (ungrid canvas)
	   (send paint:pc :Draw-rectangle (send canvas :width) (send canvas :height) 0 0
		 tv:alu-xor))
	  ))))) 


