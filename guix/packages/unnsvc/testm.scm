;; -*- geiser-scheme-implementation: guile -*-
(define-module (unnsvc testm)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix build-system gnu)
  #:use-module (guix licenses)
  #:export (my-hello))

(define (my-hello)
  (package
    (name "my-hello")
    (version "2.10")
    (source (origin
            (method url-fetch)
            (uri (string-append "mirror://gnu/hello/hello-" version
                                ".tar.gz"))
            (sha256
             (base32
              "0ssi1wpaf7plaswqqjwigppsg5fyh99vdlb9kzl7c9lng89ndq1i"))))
    (build-system gnu-build-system)
    (synopsis "my-hello")
    (description "my-hello")
    (home-page "https://www.gnu.org/software/hello/")
    (license gpl3+)))
