#lang racket

(provide get-posts-title-and-url
         get-post-detail)

(define (get-posts-title-and-url)
  `(("posts/post-1" "post 1")
    ("posts/post-2" "post 2")
    ("posts/post-3" "post 3")))

(define (get-post-detail post-path)
  (values post-path post-path))