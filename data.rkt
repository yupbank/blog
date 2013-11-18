#lang racket
(require xml markdown)

(provide get-posts-info
         get-post-detail)

(define (get-posts-info)
  (let ([posts (filter (lambda (x) (not (null? x)))
                       (map build-post-info (all-posts-file-name)))])
    posts))

(define (get-post-detail year month day title)
  (let ([file-name (string-append (string-join (list year month day title) "-") ".md")])
    (values title (string-join (list year month day) "-")
            (map xexpr->string (read-markdown-content file-name)))))

;; Define post directory
(define post-dir "posts")

;; List all posts name in directory post-dir
(define (all-posts-file-name)
  (let* ([posts-dir (build-path (current-directory) post-dir)]
         [all-files (map path->string (with-handlers
                                       ([exn:fail:filesystem?
                                         (lambda (exn) '())])
                                       (directory-list posts-dir)))])
    (sort all-files string>?)))

;; Split file-name.
;; e.g. "2013-10-12-post-name.md" -> '("2013" "10" "12" "post-name")
(define (split-post-file-name file-name)
  (let ([match-result (regexp-match* #rx"^([^-]*)-([^-]*)-([^-]*)-(.*)\\.md$"
                                     file-name #:match-select values)])
    (if (null? match-result)
        '()
        (cdr (car match-result)))))

;; Build post url, post time, post name from post file name
;; e.g. "2013-10-12-post-name.md" ->
;;      '("posts/2013/10/12/post-name" "2013-10-12" "post-name")
(define (build-post-info file-name)
  (let ([splited-name (split-post-file-name file-name)])
    (if (null? splited-name)
        '()
        (list (string-join (cons (string-append "/" post-dir) splited-name) "/")
              (string-join (take splited-name 3) "-")
              (cadddr splited-name)))))

;; Read markdown file content and convert to list of xexpr
(define (read-markdown-content file-name)
  (with-input-from-file (string-append post-dir "/" file-name) read-markdown))
