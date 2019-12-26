(in-package :web-test3)

(defun make-post-json (id title nickname)
  (st-json:jso
   "id" id
   "title" title
   "nickname" nickname))

(defun test-post-list ()
  (let ((json (st-json:jso)))
    (setf (st-json:getjso "list" json)
          (list (make-post-json 3 "title3" "aur1")
                (make-post-json 2 "title2" "aur1")
                (make-post-json 1 "title1" "aur2")))
    (setf (st-json:getjso "totalPage" json) 20)
    (setf (st-json:getjso "currentPage" json) 1)
    (st-json:write-json-to-string json)))

(defun get-post-list (&optional page)
  "Return a list of post titles."
  (let* ((json (st-json:jso))
         (p (if (not page)
                1
                (if (stringp page)
                    (parse-integer page)
                    page)))
         (total-page-count (db-total-page-count))
         (post-list (db-read-post-of-page p)))
    (format t "page : ~a" p)
    (setf (st-json:getjso "totalPage" json) total-page-count)
    (setf (st-json:getjso "currentPage" json) p)
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

(defun get-post (post-id)
  (let ((post (db-post-find post-id)))
    (with-slots (title content author-id author-nickname) post
      (st-json:write-json-to-string
       (st-json:jso
        "title" title
        "content" content
        "author" author-id
        "nickname" author-nickname)))))
