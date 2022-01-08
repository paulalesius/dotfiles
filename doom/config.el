;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Default is 800kb.
(setq gc-cons-threshold (* 50 1000 1000))

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Paul Alesius"
      user-mail-address "paul@unnservice.com"
      user-real-login-name "paulalesius")

;; Ensure encoding
(set-language-environment "UTF-8")
(set-default-coding-systems 'utf-8)

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; :size 12
(setq doom-font (font-spec :family "Fira Code" :size 13 :weight 'Regular))
;; Don't know what variable-pitch is
;; ;;doom-variable-pitch-font (font-spec :family "Noto Serif" :size 13)
;;ivy-posframe-font (font-spec :family "Fira Code" :size 15))

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)


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
  (setq doom-modeline-buffer-file-name-style 'truncate-from-project
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
