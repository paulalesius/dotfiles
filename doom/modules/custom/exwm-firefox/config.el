;;; custom/exwm-firefox/config.el -*- lexical-binding: t; -*-


(use-package! exwm-firefox-evil
  ;;:after (exwm, evil)
  :after (exwm)
  :config
  (add-hook 'exwm-manage-finish-hook #'exwm-firefox-evil-activate-if-firefox))
