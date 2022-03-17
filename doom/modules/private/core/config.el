;;; custom/core/config.el -*- lexical-binding: t; -*-


(use-package! time
  :custom
  (display-time-format "%a %H:%M:%S %Y-%m-%d" "Set time display format to include week")
  (display-time-day-and-date 't "Display day and date as well as time")
  (display-time-24hr-format 't "Uropeen")
  :config
  (display-time-mode 1))

(use-package! battery
  :config
  (display-battery-mode 1))

(use-package! frame
  :custom
  (window-divider-default-bottom-width 1)
  (window-divider-default-right-width 1)
  :config
  (window-divider-mode 1))

(use-package! menu-bar
  :config
  (menu-bar-mode -1))

(use-package! tool-bar
  :config
  (tool-bar-mode -1))

(use-package! scroll-bar
  :config
  (scroll-bar-mode -1))

(use-package! fringe
  :config
  (fringe-mode 1))

(use-package! goto-addr
  :config
  ;; Only works in emacs 28, emacs 27 has only goto-address-mode
  (global-goto-address-mode 1))
