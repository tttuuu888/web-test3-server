(defsystem "web-test3"
  :version "0.1.0"
  :author ""
  :license ""
  :depends-on ("vecto"
               "hunchentoot"
               "trivia"
               "mito"
               "iterate")
  :components ((:module "src"
                :components
                ((:file "package")
                 (:file "main" :depends-on ("db"))
                 (:file "db"))))
  :description ""
  :in-order-to ((test-op (test-op "web-test3/tests"))))

(defsystem "web-test3/tests"
  :author ""
  :license ""
  :depends-on ("web-test3"
               "rove")
  :components ((:module "tests"
                :components
                ((:file "main"))))
  :description "Test system for web-test3"
  :perform (test-op (op c) (symbol-call :rove :run c)))
