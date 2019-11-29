(in-package :web-test3)

(defun test-post-list ()
  (let ((json (st-json:read-json-from-string "{}")))
    (setf (st-json:getjso "list" json)
          '((1 "title1") (2 "title2") (3 "title3")))
    (st-json:write-json-to-string json)))

(defun get-post-list (&optional page)
  "Return a list of post titles."
  (test-post-list))
