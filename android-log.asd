(defsystem "android-log"
  :description "CFFI bindings to android log library."
  :version "0.0.1"
  :author "Grolter <varedif.a.s@gmail.com>"
  :license "Apache 2.0"
  :depends-on ("cffi")
  :components ((:file "packages")
               (:file "android-log-cffi")
               (:file "android-log")))
