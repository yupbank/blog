#lang racket
(require web-server/servlet
         web-server/servlet-env)

(define (blog-start req)
  (blog-dispatch req))

(define-values (blog-dispatch blog-url)
  (dispatch-rules
   [("") blog-list-posts]
   [("posts" (string-arg)) blog-review-post]
   [else blog-list-posts]))

(define (blog-list-posts req)
  (response/xexpr
   `(html (head (title "blog"))
          (body (h1 "new blog main page")
                (a ([href "/posts/post-1"])
                   "post 1")
                (a ([href "/posts/post-2"])
                   "post 2")
                (a ([href "/posts/post-3"])
                   "post 3")))))

(define (blog-review-post req blog-name)
  (response/xexpr
   `(html (head (title ,blog-name))
          (body (p ,blog-name)))))

(serve/servlet blog-start
               #:file-not-found-responder blog-dispatch)