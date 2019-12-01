(in-package :web-test3)

(mito:deftable user ()
  ((id :col-type (:varchar 24) :primary-key t)
   (name :col-type (:varchar 24))
   (nickname :col-type (:varchar 24))
   (email :col-type (:varchar 64))
   (password :col-type (:varchar 24))))

(mito:deftable post ()
  ((title :col-type (:varchar 128))
   (content :col-type :text)
   (author :col-type user)
   (author-nickname :col-type (:varchar 24))))

(defun db-init ()
  (format t "db-init~%")
  (mito:connect-toplevel :sqlite3 :database-name "web-test.sqlite")
  (mito:table-definition 'user)
  (mito:table-definition 'post)
  (mito:ensure-table-exists 'user)
  (mito:ensure-table-exists 'post))

(defun db-user-duplicate-t (id email)
  (or (mito:find-dao 'user :id id) (mito:find-dao 'user :email email)))

(defun db-user-add (id name nickname email password)
  (if (db-user-duplicate-t id email)
      'exists
      (mito:create-dao 'user :id id
                             :name name
                             :nickname nickname
                             :email email
                             :password password)))

(defun db-user-remove (id)
  (let ((user (mito:find-dao 'user :id id)))
    (if (not user)
        'not-exists
        (mito:delete-dao user))))

(defun db-user-find (id)
  (mito:find-dao 'user :id id))

(defun db-add-post (title content author)
  (mito:create-dao 'post :title title :content content :author author))

(defun db-test ()
  (format t "db test"))
