#lang racket
(require web-server/servlet
         web-server/templates
         web-server/servlet-env
         xml)

(define (blog-start req)
  (blog-dispatch req))

(define-values (blog-dispatch blog-url)
  (dispatch-rules
   [("") blog-list-posts]
   [("posts" (string-arg)) blog-review-post]
   [else blog-list-posts]))

(define (blog-list-posts req)
  (posts-list "blog" (xexpr->string `(body (h2 "My blog")
                                           (a ([href "/posts/post-1"])
                                              "post 1")
                                           (br)
                                           (a ([href "/posts/post-2"])
                                              "post 2")
                                           (br)
                                           (a ([href "/posts/post-3"])
                                              "post 3")))))

(define (blog-review-post req blog-name)
  (response/xexpr
   `(html (head (title ,blog-name))
          (body (p ,blog-name)))))

(define (posts-list title body)
  (response/xexpr
   (make-cdata #f #f (include-template "index.html"))))

(serve/servlet blog-start
               #:file-not-found-responder blog-dispatch
               #:servlet-path "/"
               #:extra-files-paths (list (current-directory)))