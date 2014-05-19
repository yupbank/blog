#lang racket
(require web-server/servlet
         web-server/templates
         web-server/servlet-env
         xml
         "data.rkt")

(define (blog-start req)
  (blog-dispatch req))

(define-values (blog-dispatch blog-url)
  (dispatch-rules
   [("posts" (string-arg) (string-arg) (string-arg) (string-arg)) blog-review-post]
   [else blog-list-posts]))

(define (blog-list-posts req)
  (posts-list (get-posts-info)))

(define (blog-review-post req year month day post-title)
  (let-values ([(title time content) (get-post-detail year month day post-title)])
    (response/xexpr
     (make-cdata #f #f (include-template "post.html")))))

(define (posts-list elements)
  (response/xexpr
   (make-cdata #f #f (include-template "index.html"))))

(let ([args (vector->list (current-command-line-arguments))])
  (when (not (null? args))
        (current-directory (path->complete-path (car args)))))

(serve/servlet blog-start
               #:listen-ip "0.0.0.0"
               #:port 8080
               #:command-line? #t
               #:file-not-found-responder blog-dispatch
               #:servlet-path "/"
               #:servlets-root (current-directory)
               #:server-root-path (current-directory)
               #:extra-files-paths (list (current-directory)))
