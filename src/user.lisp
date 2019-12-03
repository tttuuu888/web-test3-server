(in-package :web-test3)

(defun user-exists-p (id email)
  (format t "user id ~a email ~a~%" id email)
  (if (db-user-duplicate-t id email)
      (make-error-json "user-already-exists")
      (st-json:write-json-to-string
       (make-json :status "success"))))

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
                      (make-json :id id
                                 :nickname nickname)))))))

(defun user-valid-p (id password)
  (let ((user (db-user-find id)))
    (and user (equal password (slot-value user 'password)))))

(defun user-login (json)
  (let* ((id (st-json:getjso "id" json))
        (password (st-json:getjso "password" json))
        (user (db-user-find id)))
    ;; (format t "id : ~a, pw : ~a session id :~a ~%" id password (hunchentoot:session-value :id))
    (if (not (and user (equal password (slot-value user 'password))))
        (make-error-json "user-not-valid")
        (progn
          (hunchentoot:start-session)
          (setf (hunchentoot:session-value :id) id)
          (st-json:write-json-to-string
           (make-json :user
                      (make-json :id id
                                 :nickname (slot-value user 'nickname))))))))

(defun user-logout (json)
  (let ((id (st-json:getjso "id" json)))
    (format t "id : ~a" id)
    (setf (hunchentoot:session-value :id) "")
    (st-json:write-json-to-string
     (make-json :user "logout"))))
