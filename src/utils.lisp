(in-package :web-test3)

(defun make-error-json (error-type)
  (let ((json (st-json:read-json-from-string "{}")))
    (setf (st-json:getjso "error" json) error-type)
    (st-json:write-json-to-string json)))

(defun make-json (key value &rest pairs)
  (let ((json (st-json:read-json-from-string "{}")))
    (loop for k = key
          for v = value
          while k
          do
             (format t "a:~a, b:~a" k v)
             (setf (st-json:getjso (string k) json) v)
             (setf key   (pop pairs)
                   value (pop pairs)))
    json))
