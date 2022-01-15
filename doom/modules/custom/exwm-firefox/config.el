;;; custom/exwm-firefox/config.el -*- lexical-binding: t; -*-


(use-package! exwm-firefox-evil
  ;;:after (exwm)
  :commands (exwm-firefox-evil-activate-if-firefox)
  :hook (exwm-manage-finish . 'exwm-firefox-evil-activate-if-firefox))
