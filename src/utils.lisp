(in-package :web-test3)

(defun make-error-json (error-type)
  (let ((json (st-json:read-json-from-string "{}")))
    (setf (st-json:getjso "error" json) error-type)
    (st-json:write-json-to-string json)))
