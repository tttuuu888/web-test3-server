(in-package :web-test3)

(defun make-post-json (id title nickname)
  (let ((json (st-json:read-json-from-string "{}")))
    (setf (st-json:getjso "id" json) id)
    (setf (st-json:getjso "title" json) title)
    (setf (st-json:getjso "nickname" json) nickname)
    json))

(defun test-post-list ()
  (let ((json (st-json:read-json-from-string "{}")))
    (setf (st-json:getjso "list" json)
          (list (make-post-json 3 "title3" "aur1")
                (make-post-json 2 "title2" "aur1")
                (make-post-json 1 "title1" "aur2")))
    (setf (st-json:getjso "totalPage" json) 20)
    (setf (st-json:getjso "currentPage" json) 1)
    (st-json:write-json-to-string json)))


(defun test-post-list2 ()
  (let ((json (st-json:read-json-from-string "{}")))
    (setf (st-json:getjso "list" json)
          (list (make-post-json 3 "title11223" "author1")
                (make-post-json 2 "title11222" "author2")
                (make-post-json 1 "title11221" "author1")))
    (setf (st-json:getjso "totalPage" json) 20)
    (setf (st-json:getjso "currentPage" json) 1)
    (st-json:write-json-to-string json)))



(defun get-post-list (&optional page)
  "Return a list of post titles."
  (let* ((json (st-json:read-json-from-string "{}"))
         (p (if (not page) 1 (parse-integer page)))
         (post-list (db-read-recent-post-list)))
    (format t "page : ~a" p)
    (setf (st-json:getjso "totalPage" json) 20)
    (setf (st-json:getjso "currentPage" json) 1)
    (setf (st-json:getjso "list" json)
          (mapcar (lambda (x) (make-post-json
                               (mito:object-id x)
                               (slot-value x 'title)
                               (slot-value x 'author-nickname)))
                  post-list))
    (st-json:write-json-to-string json)))


  (defun write-post (user-id title content)
  (let ((user (db-user-find user-id)))
    (format t "id : ~a title : ~a content : ~a~%" user-id title content)
    (if (not user)
        (make-error-json "user-not-exists")
        (let ((post-id (db-add-post title content user)))
          (st-json:write-json-to-string
           (make-json :status "success"
                      :postid post-id))))))
