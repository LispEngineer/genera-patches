;;; -*- Mode : LISP; Syntax: Common-Lisp; Package: USER -*-

(fs:set-logical-pathname-host "SYS" :translations
  '(("sys:site;**;*.*.*" "DIS-LOCAL-HOST:>sys>site>**>*.*.*")
    ("sys:**;*.*.*" "DIS-LOCAL-HOST:>rel-8-3>sys>**>*.*.*")))
