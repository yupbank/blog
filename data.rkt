#lang racket

(provide load-posts
         get-posts-title-and-url
         get-post-detail)

(define (load-posts)
  (let ([posts (filter (lambda (x) (not (null? x)))
                       (map build-post-url-and-name (all-posts-file-name)))])
    (set! post-list posts)
    (map (lambda (url-name) (add-post-content (car url-name) (cadr url-name))) posts)))

(define (get-posts-title-and-url) post-list)

(define (get-post-detail year month day title)
  (let ([url (string-join (list "posts" year month day title) "/")])
    (values url (get-post-content url))))

;; Define a list of post: list of (post-url post-name)
(define post-list '())

;; Define a hash table: elements of (post-url . post-content)
(define posts-content (make-hash '()))
(define (add-post-content url content) (hash-set! posts-content url content))
(define (get-post-content url) (hash-ref posts-content url (lambda () "")))

;; List all posts name in directory "posts"
(define (all-posts-file-name)
  (let ([posts-dir (build-path (current-directory) "posts")])
    (map path->string (with-handlers ([exn:fail:filesystem?
                                       (lambda (exn) '())])
                                     (directory-list posts-dir)))))

;; Split file-name.
;; e.g. "2013-10-12-post-name.md" -> '("2013" "10" "12" "post-name")
(define (split-post-file-name file-name)
  (let ([match-result (regexp-match* #rx"([^-]*)-([^-]*)-([^-]*)-(.*)\\..*"
                                     file-name #:match-select values)])
    (if (null? match-result)
        '()
        (cdr (car match-result)))))

;; Build post url and name from post file name
;; e.g. "2013-10-12-post-name.md" -> '("posts/2013/10/12/post-name" "post-name")
(define (build-post-url-and-name file-name)
  (let ([splited-name (split-post-file-name file-name)])
    (if (null? splited-name)
        '()
        (list (string-join (cons "posts" splited-name) "/") (cadddr splited-name)))))
