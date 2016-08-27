;;; -*- Mode : LISP; Syntax: Common-Lisp; Package: USER -*-

(fs:set-logical-pathname-host "SYS" :translations
  '(("sys:site;**;*.*.*" "DIS-SYS-HOST:>sys>site>**>*.*.*")
    ("sys:**;*.*.*" "LOCAL|CDROM6:>SYS>**>*.*;*")))
