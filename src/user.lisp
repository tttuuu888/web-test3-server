(in-package :web-test3)

(defun user-add (json)
  (let ((id (st-json:getjso "id" json))
        (password (st-json:getjso "password" json))
        (name (st-json:getjso "name" json))
        (email (st-json:getjso "email" json))
        (nickname (st-json:getjso "nickname" json)))
    ;; (format t "~% id:~a, name:~a email:~a, nickname:~a, password:~a~%" id name email nickname password)
    (if (db-user-duplicate-t id email)
        (make-error-json "user-already-exists")
        (progn
          (db-user-add id name nickname email password)
          (st-json:write-json-to-string
           (make-json :user
                      (make-json :id "testid"
                                 :nickname "test-nick")))))))

(defun user-login (json)
  (let ((id (st-json:getjso "id" json))
        (password (st-json:getjso "password" json)))
    ;; (format t "id : ~a, pw : ~a session id :~a ~%" id password (hunchentoot:session-value :id))
    (hunchentoot:start-session)
    (setf (hunchentoot:session-value :id) id)
    (st-json:write-json-to-string
     (make-json :user
                (make-json :id id
                           :nickname "test-nick")))))

(defun user-logout (json)
  (let ((id (st-json:getjso "id" json)))
    (format t "id : ~a" id)
    (setf (hunchentoot:session-value :id) "")
    (st-json:write-json-to-string
     (make-json :user "logout"))))
