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
        (let* ((password (password-to-hash-and-salt password))
               (password-salt (car password))
               (password-hash (cadr password)))
          (db-user-add id name nickname email password-salt password-hash)
          (st-json:write-json-to-string
           (make-json :user
                      (make-json :id id
                                 :nickname nickname)))))))

(defun user-valid-p (id password)
  (let ((user (db-user-find id)))
    (and user
         (check-password password
                         (slot-value user 'password-salt)
                         (slot-value user 'password-hash)))))

(defun user-login (json)
  (let* ((id (st-json:getjso "id" json))
        (password (st-json:getjso "password" json))
        (user (db-user-find id)))
    ;; (format t "id : ~a, pw : ~a session id :~a ~%" id password (hunchentoot:session-value :id))
    (if (not (user-valid-p id password))
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


(defun password-to-hash-and-salt (password)
  (last
   (cl-ppcre:split "\\$"
                   (ironclad:pbkdf2-hash-password-to-combined-string
                    (string-to-byte-array password)))
   2))

(defun check-password (password salt password-hash)
  (ironclad:pbkdf2-check-password
   (string-to-byte-array password)
   (concatenate 'string "PBKDF2$SHA256:1000$" salt "$" password-hash)))
