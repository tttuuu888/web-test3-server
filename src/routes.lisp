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
(defun test2 (word) (concatenate 'string "tptp : " word))
(defun test3 (word)
  (format t "test word ~a~%" (test2 word))
  word)

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
  ;; (setf (hunchentoot:session-value 'test) "tptp")
  ;; (format t "session : ~a~%" (hunchentoot:session-value 'test))
  (make-error-json "user-not-exits"))

(easy-routes:defroute check-user ("/user/exists-p" :method :get
                                                 :decorators (easy-routes:@html))
    (&get id email)
  (dev-allow-origin)
  (user-exists-p id email))

(easy-routes:defroute add-user ("/user/add" :method :post
                                            :decorators (easy-routes:@json))
    ()
  (let* ((data-string (hunchentoot:raw-post-data :force-text t))
         (json (st-json:read-json-from-string data-string))
         (auth (st-json:getjso "auth" json)))
    (dev-allow-origin)
    (if auth
        (user-add auth)
        (make-error-json "wrong-format"))))

(easy-routes:defroute login-user ("/user/login" :method :post
                                                :decorators (easy-routes:@json))
    ()
  (let* ((data-string (hunchentoot:raw-post-data :force-text t))
         (json (st-json:read-json-from-string data-string))
         (auth (st-json:getjso "auth" json)))
    (dev-allow-origin)
    (if auth
        (user-login auth)
        (make-error-json "wrong-format"))))

(easy-routes:defroute logout-user ("/user/logout" :method :post
                                                  :decorators (easy-routes:@json))
    ()
  (let* ((data-string (hunchentoot:raw-post-data :force-text t))
         (json (st-json:read-json-from-string data-string))
         (auth (st-json:getjso "auth" json)))
    (dev-allow-origin)
    (if auth
        (user-logout auth)
        (make-error-json "wrong-format"))))

(easy-routes:defroute writepost-user ("/user/writepost" :method :post
                                                        :decorators (easy-routes:@json))
    ()
  (let* ((data-string (hunchentoot:raw-post-data :force-text t))
         (json (st-json:read-json-from-string data-string))
         (user-id (st-json:getjso "id" json))
         (title (st-json:getjso "title" json))
         (content (st-json:getjso "content" json)))
    (format t "json ~a~%" json)
    (dev-allow-origin)
    (write-post user-id title content)))


(easy-routes:defroute postid ("/post" :method :get
                                      :decorators (easy-routes:@json))
    (&get postid)
  (format t "post id : ~a~%" postid)
  (dev-allow-origin)
  (get-post postid))

(easy-routes:defroute post-delete ("/post/delete" :method :get
                                                  :decorators (easy-routes:@json))
    (&get postid)
  (format t "post id : ~a~%" postid)
  (dev-allow-origin)
  (delete-post postid))

(easy-routes:defroute home ("/" :method :get
                                :decorators (easy-routes:@json))
    (&get (page :init-form 1))
  (dev-allow-origin)
  (get-post-list page))

(easy-routes:defroute home2 ("/list" :method :get
                                     :decorators (easy-routes:@json))
    (&get (page :init-form 1 :parameter-type 'integer))
  (dev-allow-origin)
  (get-post-list page))


(easy-routes:defroute search-type ("/search/:search-type" :method :get
                                       :decorators (easy-routes:@json))
    (&get (keywords :parameter-type 'list)
          (page :init-form 1 :parameter-type 'integer))
  (dev-allow-origin)
  ;; (format t "search-type: ~a, keywords: ~a, page: ~a" search-type keywords page)
  (get-search-result search-type keywords page))


(easy-routes:defroute me ("/me" :method :get
                                :decorators (easy-routes:@html))
    ()
  (dev-allow-origin)
  (format nil "You are logged out."))

(easy-routes:defroute tptp ("/tp/:x/:xx" :method :get
                                     :decorators (easy-routes:@html))
    (y &get z)
  (dev-allow-origin)
  (format t "x: ~a, xx: ~a, y: ~a, z: ~a," x xx y z))
