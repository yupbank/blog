#lang racket

(provide get-posts-title-and-url
         get-post-detail)

(define (get-posts-title-and-url)
  (filter (lambda (x) (not (null? x)))
	  (map build-post-url-and-name (all-posts-file-name))))

(define (get-post-detail post-path)
  (values post-path post-path))

; List all posts name in directory "posts"
(define (all-posts-file-name)
  (let ([posts-dir (build-path (current-directory) "posts")])
    (map path->string (with-handlers ([exn:fail:filesystem?
				       (lambda (exn) '())])
				     (directory-list posts-dir)))))

; Split file-name.
; e.g. "2013-10-12-post-name.md" -> '("2013" "10" "12" "post-name")
(define (split-post-file-name file-name)
  (let ([match-result (regexp-match* #rx"([^-]*)-([^-]*)-([^-]*)-(.*)\\..*"
				     file-name #:match-select values)])
    (if (null? match-result)
	'()
	(cdr (car match-result)))))

; Build post url and name from post file name
; e.g. "2013-10-12-post-name.md" -> '("posts/2013/10/12/post-name" "post-name")
(define (build-post-url-and-name file-name)
  (let ([splited-name (split-post-file-name file-name)])
    (if (null? splited-name)
	'()
	(list (string-join (cons "posts" splited-name) "/") (cadddr splited-name)))))
