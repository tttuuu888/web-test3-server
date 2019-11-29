(in-package :web-test3)

(defun make-post-json (id title)
  (let ((json (st-json:read-json-from-string "{}")))
    (setf (st-json:getjso "id" json) id)
    (setf (st-json:getjso "title" json) title)
    json))

(defun test-post-list ()
  (let ((json (st-json:read-json-from-string "{}")))
    (setf (st-json:getjso "list" json)
          (list (make-post-json 3 "title3")
                (make-post-json 2 "title2")
                (make-post-json 1 "title1")))
    (st-json:write-json-to-string json)))


(defun test-post-list2 ()
  (let ((json (st-json:read-json-from-string "{}")))
    (setf (st-json:getjso "list" json)
          (list (make-post-json 3 "title11223")
                (make-post-json 2 "title11222")
                (make-post-json 1 "title11221")))
    (st-json:write-json-to-string json)))

(defun get-post-list (&optional page)
  "Return a list of post titles."
  (let ((p (if (not page) 1 (parse-integer page))))
    (format t "page : ~a" p)
    (if (equal p 2)
        (test-post-list2)
        (test-post-list))))
