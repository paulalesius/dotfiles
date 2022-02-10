;;; private/guix/config.el -*- lexical-binding: t; -*-


(use-package! emacs-guix
  ;;:ensure t
  :hook
  (scheme-mode . guix-devel-mode)
  :config
  (map!
   :map guix-devel-mode-map))
