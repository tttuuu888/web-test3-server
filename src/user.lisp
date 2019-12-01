(in-package :web-test3)

(defun user-add (id name email password)
  (if (db-user-duplicate-t id email)
      (make-error-json "user-already-exists")
      (db-user-add id name email password)))
