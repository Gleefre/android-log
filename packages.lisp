(defpackage #:android-log/cffi
  (:use #:cffi)
  (:import-from #:cl #:&rest #:in-package)
  (:export #:liblog

           #:priority
           #:buffer

           #:message

           #:vprint
           #:print
           #:write

           #:buffer-print
           #:buffer-write

           #:write-message

           #:set-default-tag

           #:get-minimum-priority
           #:set-minimum-priority

           #:is-loggable
           #:%is-loggable

           #:call-logd-logger-function
           #:call-stderr-logger-function
           #:set-logger-function

           #:log-and-abort
           #:call-default-aborter-function
           #:call-stored-aborter-function
           #:set-aborter-function))

(defpackage #:android-log
  (:use #:cl)
  (:local-nicknames (#:log #:android-log/cffi))
  (:export #:init
           #:quit))
