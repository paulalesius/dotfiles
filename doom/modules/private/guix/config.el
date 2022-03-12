;;; private/guix/config.el -*- lexical-binding: t; -*-

(use-package! emacs-guix
  ;;:ensure t
  :hook
  (scheme-mode . guix-devel-mode))
  ;; Use guix repl instead of plain guile repl
   ;;(scheme-mode . guix-scheme-mode)
;;  :config
;;  (map!
;;   :map guix-devel-mode-map))

