;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Default is 800kb.
(setq gc-cons-threshold (* 50 1000 1000))

;; Ensure encoding
(set-language-environment "UTF-8")
(set-default-coding-systems 'utf-8)
;; Remove all window manager decorations
;;(set-frame-parameter nil 'undecorated t)
;; Looks ugly and doesn't align with modeline theme, and needs to use default-frame-alist to apply to all frames
;;(modify-frame-parameters (selected-frame) '((right-divider-width . 10) (bottom-divider-width . 10)))

;; @TODO This works but is probably not the idiomatic Doom way, should really modify initial-frame-alist and default-frame-alist
;; and I don't know the idiomatic way of setting these variables yet.
;;
;; - tried running emacsclient with --frame-parameters="'((fullscreen . fullboth)(undecorated . t))"
;; - tried adding a hook to init.el in doom:
;;   (add-hook 'before-make-frame-hook
;;     #'(lambda ()
;;       (add-to-list 'default-frame-alist '(fullscreen . fullboth))
;;       (add-to-list 'default-frame-alist '(undecorated . t))))
;;   But only fullscreen seems to take effect when the emacsclient creates the frame, we still have decoration fringes
;; - tried (set-frame-parameter) in init.el, still no effect
(modify-frame-parameters (selected-frame '((undecorated . t))))

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq gc-cons-threshold (* 50 1000 1000)

      user-full-name "Paul Alesius"
      user-mail-address "paul@unnservice.com"
      user-real-login-name "paulalesius"

      ;;; doom core
      doom-theme 'doom-one
      doom-font (font-spec :family "Fira Code" :size 12 :weight 'Regular) ;;semi-light/...
      ;;; doom-variable-pitch-font (font-spec :family "Noto Serif" :size 10)
      ;;; doom-big-font ... used in doom-big-font-mode
      display-line-numbers-type 'relative

      ;;; org mode
      org-directory "~/org/")

;; Startup hook from https://config.daviwil.com/emacs
(add-hook! 'emacs-startup-hook
  (lambda ()
    (message "*** Emacs loaded in %s with %d garbage collections."
             (format "%.2f seconds"
                     (float-time
                      (time-subtract after-init-time before-init-time)))
             gcs-done)))

(after! compile
  (setq compilation-scroll-output t))

;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; Disable mouse support by removing the tty setup hook
;; This seems to come from os/tty module in doom-emacs, there's no after! for it?
(remove-hook 'tty-setup-hook #'xterm-mouse-mode)

;; Make the which-key panel show much faster
;;(after! which-key
;;  (setq which-key-idle-delay 0.4))

;; Make golden-ratio work
;;(use-package! golden-ratio
;;   :after-call pre-command-hook
;;   :config
;;   (golden-ratio-mode +1)
;; Using this hook for resizing windows is less precise than
;; `doom-switch-window-hook'.
;;   (remove-hook 'window-configuration-change-hook #'golden-ratio)
;;   (add-hook 'doom-switch-window-hook #'golden-ratio))
;; Configure zoom
;;(after! zoom
;;  (zoom-mode t))

;; Show hidden dotfiles in dired
(after! dired
  (setq dired-omit-files "\`[.][.]?\'\|^.DS_Store\'\|^.project\(?:ile\)?\'\|^.\(svn\|git\)\'\|^.ccls-cache\'\|\(?:\.js\)?\.meta\'\|\.\(?:elc\|o\|pyo\|swp\|class\)\'"))

;; Remove .git as a projectile project
(after! projectile (setq projectile-project-root-files-bottom-up
	                 (remove ".git" projectile-project-root-files-bottom-up)))


(defun custom-rust-clean ()
  (interactive)
  (rustic-run-cargo-command "cargo clean"))

(defun custom-rust-npmstart ()
  (interactive)
  (rustic-run-cargo-command "npm start"))

;;(after! doom-golden-ratio
;;  (doom-golden-ratio-mode))

(after! rustic
  (map! :map rustic-mode-map
        :localleader
        (:prefix ("c" "custom")
         :desc "npm start" "s" #'custom-rust-npmstart
         :desc "cargo clean" "c" #'custom-rust-clean)))

(after! lsp-mode
  (setq lsp-restart 'auto-restart
        lsp-prefer-flymake 'nil
        lsp-rust-analyzer-cargo-load-out-dirs-from-check t
        lsp-rust-analyzer-proc-macro-enable t
        lsp-rust-server 'rust-analyzer
        lsp-ui-doc-enable 'nil
        lsp-ui-peek-enable 'nil
        lsp-ui-sideline-enable 'nil
        ;; not sure if this belongs here, should enable an icon indicating run/debug above main methods etc
        lsp-lens-enable t))

(after! doom-modeline
  (setq doom-modeline-buffer-file-name-style 'truncate-with-project
        doom-modeline-icon t
        doom-modeline-unicode-fallback t))

;; Doesn't seem to do anything when set
;;(after! evil-collection
;;  (setq evil-collection-setup-minibuffer t))

;; Custom
;;(use-package! rust-web
;;  :hook (rustic-mode . rust-web-mode-enabler))
(after! doom-themes
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t)
  (doom-themes-visual-bell-config)
  (doom-themes-org-config))

;; Make links clickable in terminals, and kill buffer once the terminal exists.
(use-package! vterm
  ;;:hook
  ;;(vterm-mode . goto-address-mode)
  :custom
  (vterm-kill-buffer-on-exit t))

;; Neotree to the right
(after! neotree
  (setq neo-window-position 'right))
