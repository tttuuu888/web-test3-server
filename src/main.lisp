(in-package :web-test3)

(defvar *server*)

(defun test2 ()
  (format t "test2~%")
  (db-test))

(defun test ()
  (test2)
  (format t "test function"))

(define-easy-handler (test :uri "/test") (word tmp)
  (setf (content-type*) "text/plain")
  (format nil "Test world : ~a, tmp: ~a" word tmp))

(define-easy-handler (test :uri "/test2") (word tmp)
  (setf (content-type*) "text/plain")
  (format nil "Test world : ~a, tmp: ~a" word tmp))

(defun main (&optional tmp)
  (declare (ignore tmp))
  (db-init)
  (format t "web test project3~%")
  (setf *server*
    (make-instance 'easy-acceptor
                   :port 4242
                   :document-root "./html/"))

  (start *server*)

  ;; for executable
  ;; (loop (sleep 10))

  )
