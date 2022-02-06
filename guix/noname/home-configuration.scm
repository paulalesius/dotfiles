;; This "home-environment" file can be passed to 'guix home reconfigure'
;; to reproduce the content of your profile.  This is "symbolic": it only
;; specifies package names.  To reproduce the exact same profile, you also
;; need to capture the channels being used, as returned by "guix describe".
;; See the "Replicating Guix" section in the manual.

(use-modules
  (gnu home)
  (gnu packages)
  (gnu services)
  (guix gexp)
  (gnu home services shells))

(home-environment
  (packages
    (map (compose list specification->package+output)
         (list "wmctrl"
               "x265"
               "ffmpeg"
               "gnupg"
               "inxi"
               "vlc"
               "edid-decode"
               "smartmontools"
               "dmidecode"
               "curl"
               "hwinfo"
               "perl"
               "openssh"
               "scrot"
               "yt-dlp"
               "file"
               "shellcheck"
               "markdown"
               "fd"
               "rsync"
               "cryptsetup"
               "brightnessctl"
               "font-fira-code"
               "font-fira-mono"
               "gcc-toolchain"
               "make"
               "cmake"
               "htop"
               "vim"
               "ripgrep"
               "libvterm"
               "git"
               "firefox"
               "btrfs-progs"
               ;; Use emacs minibuffer for GPG pin entry to gpg-agent
               "emacs-pinentry")))
  (services
    (list (service
            home-bash-service-type
            (home-bash-configuration
              (aliases
                '(("grep='grep --color" . "auto")
                  ("ll" . "ls -l")
                  ("ls='ls -p --color" . "auto")))
              (bashrc
                (list (local-file ".bashrc" "bashrc")))
              (bash-profile
                (list (local-file
                        ".bash_profile"
                        "bash_profile"))))))))
