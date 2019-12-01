(in-package :web-test3)

(defvar *server*)

(defun main (&optional tmp)
  (declare (ignore tmp))
  (db-init)
  (format t "web test project3~%")
  (setf *server*
        (make-instance
         'easy-routes:routes-acceptor
         :port 4242))

  (hunchentoot:start *server*)

  ;; for executable
  ;; (loop (sleep 10))
  )

(defun stop-server ()
  (hunchentoot:stop *server*))
