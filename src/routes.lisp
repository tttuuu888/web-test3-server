(in-package :web-test3)

(defvar *dev-mode* t)

(defun dev-allow-origin ()
  (when *dev-mode*
    (setf (hunchentoot:header-out
           :Access-Control-Allow-Origin hunchentoot:*reply*)
          "*")))

;; (defun @auth (next)
;;   (let ((*user* (hunchentoot:session-value 'user)))
;;     (if (not *user*)
;;         (hunchentoot:redirect "/login")
;;         (funcall next))))

(defun test () (format t "test word"))

(easy-routes:defroute test2 ("/test2" :method :get
                                      :decorators (easy-routes:@html))
    (&get word tmp)
  (hunchentoot:start-session)
  (format t "~a~%" 1)

  (format nil "Test word : ~a, tmp: ~a" word tmp))

(easy-routes:defroute test3 ("/test3" :method :get
                                      :decorators (easy-routes:@html))
    ()
  (setf (hunchentoot:header-out :Access-Control-Allow-Origin hunchentoot:*reply*) "*")
  (format nil "test test test"))


(easy-routes:defroute jsontest ("/jsontest" :method :get
                                         :decorators (easy-routes:@json))
    ()
  (dev-allow-origin)
  (make-error-json "user-not-exits"))

(easy-routes:defroute add-user ("/user/add" :method :post
                                            :decorators (easy-routes:@json))
    (&post auth-data)
  (let* ((data-string (hunchentoot:raw-post-data :force-text t))
         (json (st-json:read-json-from-string data-string))
         (auth (st-json:getjso "auth" json)))
    (dev-allow-origin)
    (if auth
        (user-add auth)
        (make-error-json "wrong-format"))))

(easy-routes:defroute login-user ("/user/login" :method :post
                                                :decorators (easy-routes:@json))
    (&post auth-data)
  (let* ((data-string (hunchentoot:raw-post-data :force-text t))
         (json (st-json:read-json-from-string data-string))
         (auth (st-json:getjso "auth" json)))
    ;; (format t "?? auth data ~a~%" auth-data)
    (dev-allow-origin)
    (if auth
        (user-login auth)
        (make-error-json "wrong-format"))))

(easy-routes:defroute logout-user ("/user/logout" :method :post
                                                  :decorators (easy-routes:@json))
    (&post auth-data)
  ;; (format t "?? auth data ~a~%" auth-data)
  (let* ((data-string (hunchentoot:raw-post-data :force-text t))
         (json (st-json:read-json-from-string data-string))
         (auth (st-json:getjso "auth" json)))
    (dev-allow-origin)
    (if auth
        (user-logout auth)
        (make-error-json "wrong-format"))))

(easy-routes:defroute home ("/" :method :get
                                :decorators (easy-routes:@json))
    (&get page)
  (dev-allow-origin)
  (get-post-list page))

(easy-routes:defroute home2 ("/list" :method :get
                                :decorators (easy-routes:@json))
    (&get page)
  (dev-allow-origin)
  (get-post-list page))


(easy-routes:defroute me ("/me" :method :get
                                :decorators (easy-routes:@html))
    ()
  (dev-allow-origin)
  (format nil "You are logged out."))
