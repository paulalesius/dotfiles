;;; custom/exwm-firefox/config.el -*- lexical-binding: t; -*-

(use-package! exwm-firefox-evil
  ;;:after (exwm, evil)
  :after (exwm)
  :hook
  (exwm-manage-finish . exwm-firefox-evil-activate-if-firefox)
  :config
  ;; Firefox 98 changed the window class name
  (add-to-list 'exwm-firefox-evil-firefox-class-name "firefox-default")
  ;;(add-hook 'exwm-manage-finish-hook #'exwm-firefox-evil-activate-if-firefox)
  )

;; Doesn't work, sqlite database with bookmarks is locked
;;(use-package! firefox-bookmarks)

;;(use-package! exwm-firefox
;;  :after (exwm-firefox-evil)
;;  :config
;;  (exwm-firefox-mode))
