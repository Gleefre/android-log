(in-package #:android-log)

(defun init ()
  (unless (cffi:foreign-library-loaded-p 'log:liblog)
    (cffi:load-foreign-library 'log:liblog)))

(defun quit ()
  (cffi:close-foreign-library 'log:liblog))
