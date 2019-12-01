(in-package :web-test3)

(defun user-add (json)
  (let ((id (st-json:getjso* "auth.id" json))
        (password (st-json:getjso* "auth.password" json))
        (name (st-json:getjso* "auth.name" json))
        (email (st-json:getjso* "auth.email" json))
        (nickname (st-json:getjso* "auth.nickname" json)))
    (format t "~% id:~a, name:~a email:~a, nickname:~a, password:~a~%" id name email nickname password)
    (if (db-user-duplicate-t id email)
        (make-error-json "user-already-exists")
        (progn
          (db-user-add id name nickname email password)
          (st-json:write-json-to-string
           (make-json :user
                      (make-json :id id
                                 :nickname "test-nick")))))))

(defun user-login (id password)
  (format t "id : ~a, pw : ~a" id password)
  (st-json:write-json-to-string
   (make-json :user
              (make-json :id id
                         :nickname "test-nick"))))
