#lang racket
(require xml markdown)

(provide get-posts-url-and-title
         get-post-detail)

(define (get-posts-url-and-title)
  (let ([posts (filter (lambda (x) (not (null? x)))
                       (map build-post-url-name (all-posts-file-name)))])
    posts))

(define (get-post-detail year month day title)
  (let ([file-name (string-append (string-join (list year month day title) "-") ".md")])
    (values title (map xexpr->string (read-markdown-content file-name)))))

;; Define post directory
(define post-dir "posts")

;; List all posts name in directory post-dir
(define (all-posts-file-name)
  (let ([posts-dir (build-path (current-directory) post-dir)])
    (map path->string (with-handlers ([exn:fail:filesystem?
                                       (lambda (exn) '())])
                                     (directory-list posts-dir)))))

;; Split file-name.
;; e.g. "2013-10-12-post-name.md" -> '("2013" "10" "12" "post-name")
(define (split-post-file-name file-name)
  (let ([match-result (regexp-match* #rx"^([^-]*)-([^-]*)-([^-]*)-(.*)\\.md$"
                                     file-name #:match-select values)])
    (if (null? match-result)
        '()
        (cdr (car match-result)))))

;; Build post url, post name from post file name
;; e.g. "2013-10-12-post-name.md" -> '("posts/2013/10/12/post-name" "post-name")
(define (build-post-url-name file-name)
  (let ([splited-name (split-post-file-name file-name)])
    (if (null? splited-name)
        '()
        (list (string-join (cons post-dir splited-name) "/")
              (cadddr splited-name)))))

;; Read markdown file content and convert to list of xexpr
(define (read-markdown-content file-name)
  (with-input-from-file (string-append post-dir "/" file-name) read-markdown))
