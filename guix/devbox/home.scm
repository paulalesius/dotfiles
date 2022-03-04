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
  (gnu home services desktop)
  (gnu home services shells)
  (gnu services sound))

(home-environment
  (packages
    (map (compose list specification->package+output)
         (list "wmctrl"
               "rust"
               "rust-cargo"
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
               ;; The fonts I use in emacs
               "font-fira-code"
               "font-fira-mono"
               "gcc-toolchain"
               "make"
               "cmake"
               "htop"
               "ripgrep"
               "libvterm"
               "git"
               "firefox"
               "btrfs-progs"
               ;; Use emacs minibuffer for GPG pin entry to gpg-agent
               "emacs-pinentry"
               "guile-colorized"
               "guile-readline"
               )))
  (services
   (list
    ;; Activate redshift and set geolocation to "Malmö, Sweden"
    ;; Doc: https://guix.gnu.org/en/manual/devel/en/html_node/Desktop-Home-Services.html
    (service home-redshift-service-type
             (home-redshift-configuration
              (location-provider 'manual)
              (latitude 55.604980)
              (longitude 13.003822)))
    (service home-bash-service-type
            ;; https://guix-devel.gnu.narkive.com/FdpI8yev/patch-home-guix-profile-considered-harmful
            (home-bash-configuration
             ;; Setting aliases generates .bashrc once with default script
              (aliases
               '(("ec" . "emacsclient")))
              (environment-variables
               '(
                 ("PATH" . "$PATH:$HOME/.cargo/bin")
                 ;; Default editor for when the system edits a file, such as guix edit <pkg> or visudo etc.
                 ("EDITOR" . "emacsclient")
                 ("_JAVA_AWT_WM_NONREPARENTING" . "1")
                 ))
              ;; When adding the (bashrc) element, it will include the contents
              ;; of provided file into bashrc, in addition to the default bashrc,
              ;; this may lead to duplicate content in bashrc, so don't include
              ;; the bash initialization code in it because it's already included.
              ;;(bashrc
              ;;  (list (local-file "home/.bashrc" "bashrc")))
              ;;  It already has a default bash_profile, there's no need to re-include
              ;;  an addition bash_profile initialization logic other than customization.
              ;;(bash-profile
              ;;  (list (local-file
              ;;          "home/.bash_profile"
              ;;          "bash_profile")))
              )))))
