#lang racket
(require xml markdown)

(provide load-posts
         get-posts-title-and-url
         get-post-detail)

(define (load-posts)
  (let* ([posts (filter (lambda (x) (not (null? x)))
                        (map build-post-url-name-content (all-posts-file-name)))]
         [url-name-list (map (lambda (url-name-content)
                               (take url-name-content 2)) posts)]
         [contents (map (lambda (url-name-content)
                          (add-post-content (car url-name-content)
                                            (caddr url-name-content))) posts)])
    (set! post-list url-name-list)))

(define (get-posts-title-and-url) post-list)

(define (get-post-detail year month day title)
  (let ([url (string-join (list post-dir year month day title) "/")])
    (values title (get-post-content url))))

;; Define post directory
(define post-dir "posts")

;; Define a list of post: list of (post-url post-name)
(define post-list '())

;; Define a hash table: elements of (post-url . post-content)
(define posts-content (make-hash '()))
(define (add-post-content url content) (hash-set! posts-content url content))
(define (get-post-content url) (hash-ref posts-content url (lambda () "")))

;; List all posts name in directory "posts"
(define (all-posts-file-name)
  (let ([posts-dir (build-path (current-directory) post-dir)])
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

;; Build post url, name, content from post file name
;; e.g. "2013-10-12-post-name.md" -> '("posts/2013/10/12/post-name" "post-name" content)
(define (build-post-url-name-content file-name)
  (let ([splited-name (split-post-file-name file-name)])
    (if (null? splited-name)
        '()
        (list (string-join (cons post-dir splited-name) "/")
              (cadddr splited-name)
              (read-markdown-content file-name)))))

;; Read markdown file content and convert to list of xexpr
(define (read-markdown-content file-name)
  (with-input-from-file (string-append post-dir "/" file-name) read-markdown))
