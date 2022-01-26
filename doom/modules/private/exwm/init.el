;;; custom/exwm/init.el -*- lexical-binding: t; -*-
;;
;; Don't start exwm with a command line switch.
;;
;;(defconst IS-EXWM (not (null (member "---with-exwm" command-line-args))))
;;(add-to-list 'command-switch-alist '("--with-exwm" . (lambda (_) (pop command-line-args-left))))
;;(doom-log "init.el: doom-iteractive-p is: %s" doom-interactive-p)
;;(doom-log "init.el: doom-reloading-p is: %s" doom-reloading-p)
;;(doom-log "init.el: IS-EXWM: %s" IS-EXWM)

;;(when (and doom-interactive-p
;;           (not doom-reloading-p)
;;           IS-EXWM)
  ;;(server-start)
  ;;(setenv "EDITOR" "emacsclient")
  ;;(require 'exwm)
  ;;(exwm-enable))
;;)
