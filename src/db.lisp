(in-package :web-test3)

(mito:deftable user ()
  ((id :col-type (:varchar 32) :primary-key t)
   (name :col-type (:varchar 32))
   (email :col-type (:varchar 64))
   (password :col-type (:varchar 32))))

(mito:deftable post ()
  ((title :col-type (:varchar 128))
   (content :col-type (:varchar 1024))
   (author :col-type user)))

(defun db-init ()
  (format t "db-init~%")
  (mito:connect-toplevel :sqlite3 :database-name "web-test.sqlite")
  (mito:table-definition 'user)
  (mito:table-definition 'post)
  (mito:ensure-table-exists 'user)
  (mito:ensure-table-exists 'post))

(defun user-duplicate-t (&key id email)
  (or (mito:find-dao 'user :id id) (mito:find-dao 'user :email email)))

(defun user-add (&key id name email password)
  (if (user-duplicate-t :id id :email email)
      'exists
      (mito:create-dao 'user :id id :name name :email email :password password)))

(defun user-remove (&key id)
  (let ((user (mito:find-dao 'user :id id)))
    (if (not user)
        'not-exists
        (mito:delete-dao user))))

(defun user-find (id)
  (mito:find-dao 'user :id id))

(defvar *sample-post-list*
  '("title test 1"
    "title test 2"
    "Another title"
    "Yet another title"))

(defun get-post-list (&optional page)
  *sample-post-list*)

(defun add-post (&key title content author)
  (mito:create-dao 'post :title title :content content :author author))

(defun db-test ()
  (format t "db test"))
