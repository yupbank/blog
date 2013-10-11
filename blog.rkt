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
   [("") blog-list-posts]
   [("posts" (string-arg)) blog-review-post]
   [else blog-list-posts]))

(define (blog-list-posts req)
  (posts-list "blog" "My blog" (get-posts-title-and-url)))

(define (blog-review-post req post-path)
  (let-values ([(post-name post-content) (get-post-detail post-path)])
    (response/xexpr
     `(html (head (title ,post-name))
            (body (p ,post-content))))))

(define (posts-list title body-title elements)
  (response/xexpr
   (make-cdata #f #f (include-template "index.html"))))

(serve/servlet blog-start
               #:file-not-found-responder blog-dispatch
               #:servlet-path "/"
               #:extra-files-paths (list (current-directory)))
