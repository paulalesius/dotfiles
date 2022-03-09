;; -*- geiser-scheme-implementation: guile -*-
(define-module (unnsvc kernel)
  #:use-module (gnu packages)
  #:use-module (gnu packages base)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages linux)
  #:use-module (guix licenses)
  #:use-module (guix packages)
  #:use-module (guix utils)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix build-system copy)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system linux-module)
  #:use-module (guix build-system trivial)
  #:use-module (ice-9 match)
  #:use-module (nonguix licenses)
  #:export (linux-nonfree))



;; (define kernel-version
;;   "5.16.12")

;; ;; To download and print the has:
;; ;; guix download <url to .tar.xz form kernel.org
;; (define kernel-hash
;;   "1wnpn5w0rfniy60m2a25wjm3flvpzvs2z1s4ga01b9qhbbqisnmv")

;; ;; This method is overridden from gnu/packages/linux to change the URL
;; (define (linux-urls version)
;;   "Return a list of URLS for Linux VERSION."
;;   (list
;;    (string-append "https://www.kernel.org/pub/linux/kernel/v"
;;                   (version-major version)
;;                   ".x/linux-" version ".tar.xz")))

;; ;; Override to the latest minor version and source hash (guix hash)
;; (define-public linux-5.16
;;   (corrupt-linux linux-libre-5.16 kernel-version kernel-hash))

;; ;; Overrides framework version that defaults to linux-5.15
;; (define-public linux linux-5.16)


;; (define (linux-nonfree)
;;     (package
;;       (inherit linux)
;;       (name "linux-nonfree")))
;;        (native-inputs
;;         `(("kconfig" ,(local-file
;;                        (string-append
;;                         (dirname
;;                          (current-filename)) "/kernel-" (version-major+minor kernel-version) ".config")))
;;           ,@(alist-delete "kconfig"
;;                           (package-native-inputs linux))))))
