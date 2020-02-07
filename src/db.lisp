(in-package :web-test3)

(defvar *post-per-page* 5)

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

(defun db-post-find (id)
  (mito:find-dao 'post :id id))

(defun db-search-post-by-title (keywords page)
  (let* ((ks (mapcar (lambda (k) (concatenate 'string "%%" k "%%")) keywords))
         (qs (mapcar (lambda (k) `(:like :title ,k)) ks)))
    (mito:select-dao 'post
      (sxql:order-by (:desc :created-at))
      (sxql:limit *post-per-page*)
      (sxql:where `(:or ,@qs))
      (sxql:offset (* (1- page) *post-per-page*)))))

(defun db-search-post (type keywords page)
  (let* ((ks (mapcar (lambda (k) (concatenate 'string "%%" k "%%")) keywords))
         (qs (mapcar (lambda (k) `(:like ,type ,k)) ks)))
    ;; (format t "~%type:~a keywords:~a page:~a~%" type keywords page)
    (mito:select-dao 'post
      (sxql:order-by (:desc :created-at))
      (sxql:limit *post-per-page*)
      (sxql:where `(:or ,@qs))
      (sxql:offset (* (1- page) *post-per-page*)))))

(defun db-add-post (title content author)
  "add post"
  (let ((post
          (mito:create-dao 'post :title title
                                 :content content
                                 :author author
                                 :author-nickname (slot-value author
                                                              'nickname))))
    (mito:object-id post)))

(defun db-post-remove (post)
  (mito:delete-dao post))

;; select * from post order by timestamp desc limit 20
(defun db-read-recent-post-list ()
  (mito:select-dao 'post (sxql:order-by (:desc :created-at)) (sxql:limit 20)))

(defun db-read-post-of-page (page)
  (mito:select-dao 'post
    (sxql:order-by (:desc :created-at))
    (sxql:limit *post-per-page*)
    (sxql:offset (* (1- page) *post-per-page*))))

(defun db-total-page-count ()
  (multiple-value-bind (a b) (floor (mito:count-dao 'post) *post-per-page*)
    (if (equal b 0)
        a
        (1+ a)))


)

(defun db-test ()
  (format t "db test"))
