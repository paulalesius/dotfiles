;;; ui/exwm/config.el -*- lexical-binding: t; -*-


(use-package! exwm-randr
  :custom
  (exwm-randr-workspace-monitor-plist '(0 "eDP-1") "Set monitors for randr")
  :config
  (require 'exwm-randr)
;;  (add-hook 'exwm-randr-screen-change-hook
;;            (lambda ()
;;              (start-process-shell-command
;;               "xrandr" nil "xrandr --output eDP-1 --mode 1920x1080 --rate 60.01 --dpi 158 --rotate normal")))
  (exwm-randr-enable))

(use-package! exwm
  ;;:defer t
  ;;:commands (exwm-enable)
  :after (exwm-randr)
  :custom
  (use-dialog-box nil "Disable dialog boxes since they are unusable in EXWM")
  ;;(exwm-input-line-mode-passthrough t "Pass all keypresses to emacs in line mode.")
  :hook (exwm-update-class . (lambda () (exwm-workspace-rename-buffer exwm-class-name)))
  :config
  (require 'exwm-config)
  (exwm-config-example)

  (require 'exwm-xim)
  (exwm-xim-enable)

  (exwm-input-set-key (kbd "s-&")
                      (lambda (command)
                        (interactive (list (read-shell-command "$ ")))
                        (start-process-shell-command command nil command)))

  (setq display-time-format "%H:%M:%S %Y-%m-%d"
        display-time-day-and-date 't
        display-time-24hr-format 't)
  (display-time-mode 1)
  (display-battery-mode 1)
  (window-divider-mode 0))

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


;;(use-package! framemove
;;  :after exwm
;;  ;; Enable switch frames with Meta+arrows. Doesn't seem to work for me in one frame.
;;  (require 'framemove)
;;  (framemove-default-keybindings))
