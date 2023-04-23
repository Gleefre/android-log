(in-package #:android-log/cffi)

;; Library

(define-foreign-library liblog
  (:android "liblog.so"))

;; Enumerations
;; https://developer.android.com/ndk/reference/group/logging#enumerations

(defcenum priority
  :unknown
  :default
  :verbose
  :debug
  :info
  :warn
  :error
  :fatal
  :silent)

(defcenum buffer
  :min
  (:main 0)
  :radio
  :events
  :system
  :crash
  :stats
  :security
  :kernel
  :max
  (:default #x7FFFFFFF))

;; Message structure
;; https://developer.android.com/ndk/reference/struct/android-log-message

(defcstruct (message :class message)
  (size :size)
  (buffer buffer)
  (priority priority)
  (tag :string)
  (file :string)
  (line :uint32)
  (message :string))

;; Functions
;; https://developer.android.com/ndk/reference/group/logging#functions_1

;; Simple log functions

(defcfun (vprint "__android_log_vprint") :int
  "Equivalent to LOG:PRINT, but taking a VA-LIST"
  (priority priority)
  (tag :string)
  (c-format :string)
  (va-list :pointer))

(defcfun (print "__android_log_print") :int
  "Writes a formatted string to the log, with PRIORITY and TAG."
  (priority priority)
  (tag :string)
  (c-format :string)
  &rest)

(defcfun (write "__android_log_write") :int
  "Writes the constant TEXT to the log, with PRIORITY and TAG."
  (priority priority)
  (tag :string)
  (text :string))

;; Log to buffers

(defcfun (buffer-print "__android_log_buf_print") :int
  "Writes a formatted string to the log BUFFER, with PRIORITY and TAG."
  (buffer buffer)
  (priority priority)
  (tag :string)
  (c-format :string)
  &rest)

(defcfun (buffer-write "__android_log_buf_write") :int
  "Writes the constant TEXT to the log BUFFER, with PRIORITY and TAG."
  (buffer buffer)
  (priority priority)
  (tag :string)
  (text :string))

;; Basic write-message

(defcfun (write-message "__android_log_write_log_message") :void
  "Writes the log MESSAGE. Assumes that loggability has already been checked."
  (message (:pointer (:struct message))))

;; Default tag

(defcfun (set-default-tag "__android_log_set_default_tag") :void
  "Sets the default tag if no tag is provided when writing a log message."
  (tag :string))

;; Minimum visible priority

(defcfun (get-minimum-priority "__android_log_get_minimum_priority") priority
  "Gets the minimum priority that will be logged for this process.")

(defcfun (set-minimum-priority "__android_log_set_minimum_priority") priority
  "Sets the minimum priority that will be logged for this process.
Returns the previous minimum priority."
  (priority priority))

;; Visibility of log messages

(defcfun (is-loggable "__android_log_is_loggable") :int
  "Determines if a log message with a given PRIORITY and TAG will be printed.
A non-zero result indicates yes, zero indicates false."
  (priority priority)
  (tag :string)
  (default-priority priority))

(defcfun (%is-loggable "__android_log_is_loggable_len") :int
  "Same as LOG:IS-LOGGABLE, but also takes length of the TAG."
  (priority priority)
  (tag :string)
  (length-of-tag :size)
  (default-priority priority))

;; Logger function

(defcfun (call-logd-logger-function "__android_log_logd_logger") :void
  "Writes the log message to logd.
It is the default logger function when running liblog on a device."
  (message (:pointer (:struct message))))

(defcfun (call-stderr-logger-function "__android_log_stderr_logger") :void
  "Writes the log message to stderr.
It is the default logger when running liblog on host."
  (message (:pointer (:struct message))))

(defcfun (set-logger-function "__android_log_set_logger") :void
  "Sets a user defined logger function."
  (logger-function :pointer))

;; Log-and-abort (__android_log_assert)

(defcfun (log-and-abort "__android_log_assert") :void
  "Writes an assertion failure to the log and stderr, then calls the aborter function."
  (condition :string)
  (tag :string)
  (format :string)
  &rest)

(defcfun (call-default-aborter-function "__android_log_default_aborter") :void
  "Sets android_set_abort_message() on device then aborts().
This is the default aborter function."
  (abort-message :string))

(defcfun (call-stored-aborter-function "__android_log_call_aborter") :void
  "Calls the stored aborter function."
  (abort-message :string))

(defcfun (set-aborter-function "__android_log_set_aborter") :void
  "Sets a user defined aborter function."
  (abort-function :pointer))
