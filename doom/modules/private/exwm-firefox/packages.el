;;; custom/exwm-firefox/packages.el -*- lexical-binding: t; -*-

;; Evilify Firefox with modal editing
(package! exwm-firefox-evil
  :recipe (:host github :repo "walseb/exwm-firefox-evil")
  :pin "14643ee53a506ddcb5d2e06cb9f1be7310cd00b1")

;; Doesn't work, sqlite3 database with bookmarks is locked
;;(package! ini
;;  :recipe (:host github :repo "daniel-ness/ini.el")
;;  :pin "6c91643468b834d23688d5db3e855d2d961490e7")
;;(package! firefox-bookmarks
;;  :recipe (:local-repo "/storage/src/noname/firefox-bookmarks.el"
;;           :files ("*.el")
;;           :build (:not compile)))

;; Needs further work to integrate with above
;;(package! exwm-firefox
;;  :recipe (:host github :repo "paulalesius/exwm-firefox"))
