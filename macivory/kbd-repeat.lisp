;;; -*- Package: USER; Base: 10.; Syntax: Common-lisp -*-

;(tv:set-screen-options
;  :show-machine-name-in-wholine t
;  :wholine-clock-format :dow-hh-mm-am
;  :DIM-SCREEN-AFTER-N-MINUTES-IDLE  3)
(setf si:*kbd-auto-repeat-enabled-p* t)        ; turn on keyboard auto repeat for all keys
(setf si:*kbd-auto-repeat-initial-delay* 30)   ; 60ths of a sec; default is 42
(setf si:*kbd-repetition-interval* 1)          ; 60ths of a sec; default is 2

