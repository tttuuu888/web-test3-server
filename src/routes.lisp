(in-package :web-test3)

(defvar *dev-mode* t)

(defun dev-allow-origin ()
  (when *dev-mode*
    (setf (hunchentoot:header-out
           :Access-Control-Allow-Origin hunchentoot:*reply*)
          "*")))

(defun test () (format t "test word"))

(easy-routes:defroute test2 ("/test2" :method :get
                                      :decorators (easy-routes:@html))
  (&get word tmp)
  (format nil "Test word : ~a, tmp: ~a" word tmp))

(easy-routes:defroute test3 ("/test3" :method :get
                                      :decorators (easy-routes:@html))
  ()
  (setf (hunchentoot:header-out :Access-Control-Allow-Origin hunchentoot:*reply*) "*")
  (format nil "test test test"))


(easy-routes:defroute test2 ("/jsontest" :method :get
                                         :decorators (easy-routes:@json))
  ()
  (dev-allow-origin)
  (make-error-json "user-not-exits"))

(easy-routes:defroute add-user ("/add-user" :method :post
                                            :decorators (easy-routes:@json))
  (&post auth-data)
  (let* ((data-string (hunchentoot:raw-post-data :force-text t))
         (json (st-json:read-json-from-string data-string)))
    (dev-allow-origin)
    (user-add json)))

(easy-routes:defroute login-user ("/login-user" :method :post
                                            :decorators (easy-routes:@json))
  (&post auth-data)
  (let* ((data-string (hunchentoot:raw-post-data :force-text t))
         (json (st-json:read-json-from-string data-string))
         (id (st-json:getjso* "auth.id" json))
         (pw (st-json:getjso* "auth.pw" json)))
    (dev-allow-origin)
    (user-login id pw)))


(easy-routes:defroute test3 ("/list" :method :get
                                     :decorators (easy-routes:@json))
  (&get page)
  (dev-allow-origin)
  (get-post-list page))
