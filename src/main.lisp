(in-package :web-test3)

(defvar *server*)
(defvar *custom-reply*)

(defun test2 ()
  (format t "test2~%")
  (db-test))

(defun test ()
  (test2)
  (format t "test function"))

;; (define-easy-handler (test :uri "/test") (word tmp)
;;   (setf (content-type*) "text/plain")
;;   (format nil "Test world : ~a, tmp: ~a" word tmp))

;; (define-easy-handler (test :uri "/test2") (word tmp)
;;   (setf (content-type*) "text/plain")
;;   (format nil "Test world : ~a, tmp: ~a" word tmp))

;; (define-easy-handler (add-user :uri "/add-user") ()
;;   (setf (content-type*) "text/plain")
;;   (let ((request-type (request-method *request*)))
;;     (cond ((eq request-type :get)
;;            (format nil "test get"));; handle get request
;;           ((eq request-type :post)
;;            (let* ((data-string (raw-post-data :force-text t))
;;                   (json (st-json:read-json-from-string data-string)))
;;              (format nil "id : ~a, pw : ~a"
;;                      (st-json:getjso "id" json)
;;                      (st-json:getjso "pw" json)))))))

(easy-routes:defroute test ("/test" :method :get
                                    :decorators (easy-routes:@html) )
    ()
  (format nil "test test test"))

(easy-routes:defroute test2 ("/test2" :method :get
                                      :decorators (easy-routes:@html))
    (&get word tmp)
  (format nil "Test word : ~a, tmp: ~a" word tmp))

(easy-routes:defroute add-user ("/add-user" :method :post
                                            :decorators (easy-routes:@json))
    (&post auth-data)
  (let* ((data-string (hunchentoot:raw-post-data :force-text t))
         (json (st-json:read-json-from-string data-string))
         (auth (st-json:getjso "auth" json))
         (id (st-json:getjso "id" auth))
         (pw (st-json:getjso "pw" auth)))
    (format t "id : ~a, pw : ~a~%" id pw)
    (format nil "id : ~a, pw : ~a" id pw)))


(defun main (&optional tmp)
  (declare (ignore tmp))
  (db-init)
  (format t "web test project3~%")
  (setf *custom-reply* (make-instance 'hunchentoot:reply))
  (setf (hunchentoot:header-out :headers *custom-reply*)
        (append  (hunchentoot:header-out :headers *custom-reply*)
                 '((:access-control-allow-origin . "*"))))
  (setf *server*
        (make-instance 'easy-routes:routes-acceptor
                       :port 4242
                       :reply-class *custom-reply*))

  (start *server*)

  ;; for executable
  ;; (loop (sleep 10))

  )
