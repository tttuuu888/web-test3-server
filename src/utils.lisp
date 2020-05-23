(in-package :web-test3)

(defun make-error-json (error-type)
  (let ((json (st-json:jso)))
    (setf (st-json:getjso "error" json) error-type)
    (st-json:write-json-to-string json)))

(defun make-json (key value &rest pairs)
  (let ((json (st-json:jso)))
    (loop for k = key
          for v = value
          while k
          do
             (setf (st-json:getjso (string-downcase k) json) v)
             (setf key   (pop pairs)
                   value (pop pairs)))
    json))


(defun string-to-byte-array (str)
  (map '(vector (unsigned-byte 8)) #'char-code str))

(defun byte-array-to-string (arr)
  (map 'string #'code-char arr))
