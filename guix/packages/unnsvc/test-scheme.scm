;; -*- geiser-scheme-implementation: guile -*-

(define-module (unnsvc test-scheme))

(use-modules
 (srfi srfi-9)
 (srfi srfi-9 gnu) ;; record printers
 (oop goops)
 (oop goops describe)
 (ice-9 pretty-print)
 (gnu)
 (gnu system)
 (gnu services)
 (gnu services networking)
 (gnu services base)
 (gnu services desktop)
 (gnu packages emacs)
 (gnu packages emacs-xyz))

(use-service-modules desktop)

;;(list? %desktop-services)
;; (dotted-list? %desktop-services) - t/f if dotted list

;; (define (log fmt value)
;;   (display (format #t fmt value))
;;   (newline))

;; (display (class-of %desktop-services)) ;; <<class> <pair> 12345xyz>
;; (newline)
;; (display (last-pair %desktop-services))
;; (newline)
;; (display (is-a? %desktop-services <pair>)) ;; true
;; (newline)
;; (pretty-print (car %desktop-services))

;; ;;(display (format #t "is record?: ~a\n" (record? (car %desktop-services))))
;; (log "is pair? ~a" (pair? %desktop-services))
;; (log "is lit? ~a" (list? %desktop-services))
;; (log "Is record? ~a" (record? %desktop-services))
;; (log "Is car record? ~a" (record? (car %desktop-services)))
;; (log "Is cdr record? ~a" (record? (cdr %desktop-services)))
;; (log "Is cdr list? ~a" (list? (cdr %desktop-services)))
;; ;;(pretty-print %desktop-services)

;; (newline)
;; (display (class-of %desktop-services))
;; (newline)
;; (display (is-a? <pair> %desktop-services))
;; (display (is-a? <class> %desktop-services))
;; (display (is-a? <list> %desktop-services))
;; (newline)
;; (display (car %desktop-services))
;; (newline)
;; (display (cdr %desktop-services))
;; (newline)
;; (display (length %desktop-services))
;; (newline)
;; (write "------------")
;; (newline)
;; (display (class-of (car %desktop-services)))
;; (newline)
;; (display (service? %desktop-services))
;; (newline)



(define (pretty-print-record val)
  (display (format #t "Record name: ~a\n" (record-type-name (record-type-descriptor val))))
  (display (format #t "Record value: ~a\n" val))
  (pretty-print (record-type-fields (record-type-descriptor val))))

(define (write-service-type type port)
  (format port "#<service-type ~a ~a>"
          (service-type-name type)
          (number->string (object-address type) 16)))

(define (format-svc-value svcval)
  (when (boolean? svcval) (pretty-print svcval))
  (when (list? svcval) (pretty-print svcval))
  (when (record? svcval) (pretty-print-record svcval)))

(define (all-svcs type)
  (for-each
   (lambda (svc)
     (display (format #t "---------- class-of: ~a\n" (class-of svc)))
     (if (service? svc)
         (begin
           (display (format #t "#service-kind: ~a\n" (service-kind svc)))
           (display (format #t "#service-value: ~a\n" (service-value svc)))
           (display (format #t "#service-value type: ~a\n" (class-of (service-value svc))))
           (display (format #t "#service name: ~a\n" (service-kind svc)))
           (display (format #t "#test ~a\n" (symbol->string (service-type-name (service-kind svc)))))
           (format-svc-value (service-value svc))))
    (format-svc-value svc))
   type))

;;(all-svcs %base-services)
;;(all-svcs %desktop-services)
;;(all-svcs %base-user-accounts)
;;(all-svcs (filter
;;           (lambda (service)
;;             (cond
;;              ((string= (symbol->string (service-type-name (service-kind service))) "sane") #false)
;;              ((string= (symbol->string (service-type-name (service-kind service))) "mount-setuid-helpers") #false)
;;              ((string= (symbol->string (service-type-name (service-kind service))) "network-manager-applet") #false)
;;              ((string= (symbol->string (service-type-name (service-kind service))) "modem-manager") #false)
;;              ((string= (symbol->string (service-type-name (service-kind service))) "avahi") #false)
;;              ((string= (symbol->string (service-type-name (service-kind service))) "accountsservice") #false)
;;              ((string= (symbol->string (service-type-name (service-kind service))) "cups-pk-helper") #false)
;;              ((string= (symbol->string (service-type-name (service-kind service))) "geoclue") #false)
;;              (else #true)
;;              ))
;;           %desktop-services))



;;(display (record? console-font-service-type))
;;(newline)
;;(display (class-of console-font-service-type))

;;(pair-for-each (lambda (key)
;;                 (display key)
;;                 (newline))
;;                 %desktop-services)

;; Attempt to recursivesly print out the structure
;;(define (struct-print structure)
;;  (cond ))

;;(display (list? (last-pair %desktop-services)))
;;(display "test")
;;(pair-for-each
;; (lambda (svc)
;;   (write
;;    (format #t "~a\n"
;;            (length
;;             svc))))
;; %desktop-services)
;; (display "tet")
;; (pair-for-each (lambda (svc) (display (format #t "~a\n" (record? svc)))) %desktop-services)
;;(display "test")


;; Local Variables:
;; eval: (put 'remote-let 'scheme-indent-function 1)
;; eval: (put 'with-roll-back 'scheme-indent-function 1)
;; eval: (put 'eval/error-handling 'scheme-indent-function 1)
;; End:

(define (debug-print-package pkg)
  (if (record? pkg)
      (begin
        (display (format #t "class-of: ~a\n" (class-of pkg)))
        ;;(let ((accessor (record-accessor pkg 'arguments)))
        (for-each (lambda (field)
                    (display (format #t "field: ~a\n" field)))
                  (record-type-fields (record-type-descriptor pkg))))
      (begin
        (display "Not a record"))))

;;(debug-print-package emacs-exwm)

(display (resolve-module (unnsvc test-scheme)))
