;;; custom/exwm/config.el -*- lexical-binding: t; -*-


(use-package! exwm-randr
  :custom
  (exwm-randr-workspace-monitor-plist '(0 "eDP-1") "Set monitors for randr")
  :config
  (require 'exwm-randr)
  (add-hook 'exwm-randr-screen-change-hook
            (lambda ()
              (start-process-shell-command
               "xrandr" nil "xrandr --output eDP-1 --mode 1920x1080 --rate 60.01 --dpi 158 --rotate normal")))
  (exwm-randr-enable))

(use-package! exwm
  ;;:defer t
  ;;:commands (exwm-enable)
  :after (exwm-randr)
  :custom
  (use-dialog-box nil "Disable dialog boxes since they are unusable in EXWM")
  (exwm-debug nil "Set to true to debug exwm")
  (exwm-workspace-number 4)
  ;;(exwm-input-line-mode-passthrough t "Pass all keypresses to emacs in line mode.")
  :hook (exwm-update-class . (lambda () (exwm-workspace-rename-buffer exwm-class-name)))
  :config

  (require 'exwm-xim)
  (exwm-xim-enable)

  ;; Forward "Esc" key to Emacs
  (dolist (k `(escape))
    (cl-pushnew k exwm-input-prefix-keys))

  ;; Copied from exwm-config-example
  (setq exwm-input-global-keys
        `(
          ;; 's-q': Reset (to line-mode).
          ([?\s-q] . exwm-reset)
          ;; 's-w': Switch workspace.
          ([?\s-w] . exwm-workspace-switch)
          ;; 's-r': Launch application.
          ([?\s-r] . (lambda (command)
                       (interactive (list (read-shell-command "$ ")))
                       (start-process-shell-command command nil command)))
          ;; 's-N': Switch to certain workspace.
          ,@(mapcar (lambda (i)
                      `(,(kbd (format "s-%d" i)) .
                        (lambda ()
                          (interactive)
                          (exwm-workspace-switch-create ,i))))
                    (number-sequence 0 9))))
  ;; Line-editing shortcuts
  (setq exwm-input-simulation-keys
        '(([?\C-b] . [left])
          ([?\C-f] . [right])
          ([?\C-p] . [up])
          ([?\C-n] . [down])
          ([?\C-a] . [home])
          ([?\C-e] . [end])
          ([?\M-v] . [prior])
          ([?\C-v] . [next])
          ([?\C-d] . [delete])
          ([?\C-k] . [S-end delete])))

  (exwm-enable)
  (setq display-time-format "%a %H:%M:%S %Y-%m-%d"
        display-time-day-and-date 't
        display-time-24hr-format 't)

  (display-time-mode 1)
  (display-battery-mode 1)
  (window-divider-mode 0)
  ;; Copied from (exwm-config-misc)
  (menu-bar-mode -1)
  (tool-bar-mode -1)
  (scroll-bar-mode -1)
  (fringe-mode 1))

(use-package! exwm-workspace
  :after exwm
  :custom
  (exwm-workspace-number 5 "Initial number of workspaces")
  (exwm-workspace-show-all-buffers t "Show all buffers listable in all workspaces")
  (exwm-workspace-index-map (lambda (i) (number-to-string (1+ i))) "Mapping of workspace index to number so it starts at 1 instead of 0"))

(use-package! desktop-environment
  :after exwm
  :config
  (setq
   ;; Screenshot
   desktop-environment-screenshot-command "flameshot full -p ~/Pictures"
   ;; Pulseaudio
   desktop-environment-volume-set-command "pactl -- set-sink-volume 0 %s"
   desktop-environment-volume-get-command "pactl -- get-sink-volume 0"
   desktop-environment-volume-normal-increment "+5%"
   desktop-environment-volume-normal-decrement "-5%"
   desktop-environment-volume-small-increment "+1%"
   desktop-environment-volume-small-decrement "-1%"
   desktop-environment-volume-get-regexp "\\([0-9]+%\\)"
   desktop-environment-volume-toggle-command "pactl -- set-sink-mute 0 toggle"
   desktop-environment-volume-toggle-microphone-command "pactl set-source-mute 0 toggle")
  (desktop-environment-mode))

;;(use-package! exwm-firefox
;;  :after exwm)

;;(use-package! framemove
;;  :after exwm
;;  ;; Enable switch frames with Meta+arrows. Doesn't seem to work for me in one frame.
;;  (require 'framemove)
;;  (framemove-default-keybindings))
