;; This "home-environment" file can be passed to 'guix home reconfigure'
;; to reproduce the content of your profile.  This is "symbolic": it only
;; specifies package names.  To reproduce the exact same profile, you also
;; need to capture the channels being used, as returned by "guix describe".
;; See the "Replicating Guix" section in the manual.

(use-modules
  (srfi srfi-1)
  (gnu)
  (gnu home)
  (gnu packages)
  (gnu services)
  (guix gexp)
  (gnu home services desktop)
  (gnu home services shells)
  (gnu packages emacs)
  (gnu services sound)
  ;;(gnu packages rust) Not in mainline yet, build from source
  (gnu home services)
  (gnu home services xdg))

(use-package-modules rust)

;; This is the $HOME/.guix-home profile
(home-environment

 ;; These packages are found through $HOME/.guix-home/profile, so activate access to it in bash profile.
 (packages
  (cons*
    ;; Append an additional output of rust
    ;; Adding "rust:rustfmt" to the specifications, seems to replace the original rust:out,
    ;; so add it this way instead.
    ;;(list rust "rustfmt") Not in mainline yet, build from source
    (map (compose list specification->package+output)
         (list "x265"
               "ffmpeg"
               "ffmpegthumbnailer" ;; Generate thumbnails for nautilus etc
               "gnupg"
               "vlc"
               "curl"
               "openssh"
               "scrot"
               "yt-dlp"
               "fd"
               "zip" "unzip"
               "rsync"
               ;; The fonts I use in emacs
               "font-fira-code"
               "font-fira-mono"
               "font-microsoft-impact"
               "font-adobe-source-han-sans:cn"
               "htop"
               "ripgrep"
               "git"
               "git-remote-gcrypt" ;; For encrypted git repos
               "firefox"
               "gimp"
               "python"
               ;;"rust"
               ;;"rust:rustfmt"
               ;;"rust-cargo"
               ;;"rust-analyzer"
               "libvterm" ;; Needs permission to compile, so keep in home
               "markdown"
               "xrandr"
               "node" ;; for npm
               "shellcheck" ;; For doom emacs language server
               "graphviz" ;; graphing, dot tool
               "file"
               ;; General development tools
               "gcc-toolchain" "make" "cmake"))))
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
              (guix-defaults? #t)
             ;; Setting aliases generates .bashrc once with default script
              (aliases '(("ec" . "emacsclient")
                         ("bitcoind-start" . "bitcoind -datadir=/storage/bitcoind")))
              (environment-variables '(
                 ;; Add cargo bin to path
                 ("PATH" . "${PATH}:${HOME}/.cargo/bin")
                 ;; Add pip3 to path
                 ("PATH" . "${PATH}:${HOME}/.local/bin")
                 ;; Default editor for when the system edits a file, such as guix edit <pkg> or visudo etc.
                 ("EDITOR" . "emacsclient")

                 ;; History file should be located somewher appropriate
                 ("HISTFILE" . "$XDG_CACHE_HOME/.bash_history")

                 ;; Disable, these package files will be moved into a custom channel
                 ;; Where to find package definitions for guix edit and guix package
                 ;;("GUIX_PACKAGE_PATH" . "$XDG_CONFIG_HOME/guix/packages")

                 ;; Ensure that GTK always uses x11, so that emacs with pgtk doesn't start on wayland
                 ("GDK_BACKEND" . "x11")

                 ;; Set guix-home as the profile so we manage it with this config only
                 ;; Also add the LD load path from the guix-home profile
                 ;;("GUIX_PROFILE" . "$HOME/.guix-home/profile")
                 ;;("LD_LIBRARY_PATH" . "$GUIX_PROFILE/lib")

                 ("_JAVA_AWT_WM_NONREPARENTING" . "1")

                 ;; NPM needs to use XDG dirs
                 ("NPM_CONFIG_USERCONFIG" . "$XDG_CONFIG_HOME/npm/npmrc")

                 ;; Set RUST_SRC_PATH so that rust-analyzer finds rust source code
                 ;; Doesn't work, rust-analyzer fails to find sysroot, rustc too
                 ;;("RUST_SRC_PATH" . "/storage/src/rust/rust/")
                 ("RUST_SRC_PATH" . "/home/noname/.guix-profile/lib/rustlib/src/rust/library")

                 ;; https://github.com/sindresorhus/guides/blob/main/npm-global-without-sudo.md
                 ;;
                 ;; npm config set prefix "${HOME}/.npm-packages"
                 ("NPM_PACKAGES" . "${HOME}/.npm-packages")
                 ("PATH" . "${PATH}:$NPM_PACKAGES/bin")
                 ("MANPATH" . "${MANPATH-$(manpath)}:$NPM_PACKAGES/share/man")))

              ;; Attempt to activate extra profiles
              ;;(bash-profile
              ;; (list (local-file "bash.bash_profile")))

              ;; When adding the (bashrc) element, it will include the contents
              ;; of provided file into bashrc, in addition to the default bashrc,
              ;; this may lead to duplicate content in bashrc, so don't include
              ;; the bash initialization code in it because it's already included.
              ;;(bashrc
              ;; (list (local-file "bash.bashrc")))
              ;;  (list (local-file "home/.bashrc" "bashrc")))
              ;;
              ;; The guix-home profile file should already be sourced through $HOME/.profile
              ;; which is read from $HOME/.bash_profile
              ;;(bash-profile
              ;; (list (local-file "/home/noname/.guix-home/profile/etc/profile")))
              ;;(bashrc
              ;;(list (local-file "/home/noname/.guix-home/profile/etc/profile")))
              ;;(bash-profile '("\
              ;;export HISTFILE=$XDG_CACHE_HOME/.bash_history"))
              ;;  This does seem to work
              ;;  (list (local-file
              ;;          "home/.bash_profile"
              ;;          "bash_profile")))
              ))
     (service home-xdg-user-directories-service-type
            (home-xdg-user-directories-configuration
             (desktop     "$HOME") ;; Not relevant
             (documents   "/storage/media/documents")
             (download    "/storage/media/downloads")
             (music       "/storage/media/audio")
             (pictures    "/storage/media/pictures")
             (publicshare "/storage/media/public") ;; Just not the home dir in case anything is accidentally shared
             (templates   "$HOME") ;; Not relevant
             (videos      "/storage/media/videos"))))))
