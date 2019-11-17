(in-package :web-test3)

(mito:deftable user ()
  ((name :col-type (:varchar 64))
   (email :col-type (or (:varchar 128) :null))))

(mito:deftable post ()
  ((title :col-type (:varchar 128))
   (content :col-type (:varchar 1024))
   (author :col-type user)))

(defun db-init ()
  (format t "db-init~%")
  (mito:connect-toplevel :sqlite3 :database-name "web-test")
  (mito:table-definition 'user)
  (mito:table-definition 'post)
  (mito:ensure-table-exists 'user)
  (mito:ensure-table-exists 'post))

(defun user-add (&key name email)
  (if (mito:find-dao 'user :email email)
      'exists
      (mito:create-dao 'user :name name :email email)))

(defun user-remove (&key email)
  (let ((user (mito:find-dao 'user :email email)))
    (if (not user)
        'not-exists
        (mito:delete-dao user))))

(defun user-find (&key email)
  (mito:find-dao 'user :email email))

(defun db-test ()
  (format t "db test"))
