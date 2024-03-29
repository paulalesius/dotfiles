;; -*- geiser-scheme-implementation: guile -*-
;; use (guix-scheme-mode) to indent lol!

(use-modules
 (srfi srfi-1)
 (gnu)
 (gnu system)
 (gnu packages linux)
 (gnu packages display-managers)
 ;;(gnu services pm)
 (gnu services)
 (gnu services virtualization)
 ;;(gnu services shepherd)
 (guix packages)
 (guix download)
 (guix git-download)
 (guix utils)
 (nongnu packages linux)
 (nongnu system linux-initrd)
 (unnsvc emacs))

(use-service-modules
 desktop    ;; GNOME-based desktop services, gdm, NetworkManager, etc.
 networking ;; ??
 ssh        ;; ??
 xorg       ;; Included in desktop? Probably for emacs
 vpn        ;; wireguard??
 pm
 shepherd
 )
(use-package-modules certs xdisorg)

(define kernel-version
  "5.17.1")

;; To download and print the has:
;; guix download <url to .tar.xz form kernel.org
(define kernel-hash
  "092cx18va108lb27kxx2b00ma3l9g22nmkk81034apx26bacbmbw")

;; This method is overridden from gnu/packages/linux to change the URL
(define
  (linux-urls version)
  "Return a list of URLS for Linux VERSION."
  (list
   (string-append "https://www.kernel.org/pub/linux/kernel/v"
                  (version-major version)
                  ".x/linux-" version ".tar.xz")))

;; Override to the latest minor version and source hash (guix hash)
(define-public linux-5.16
  (corrupt-linux linux-libre-5.17 kernel-version kernel-hash))

;; Overrides framework version that defaults to linux-5.15
(define-public linux linux-5.17)

(define %xorg-libinput-config
  "Section \"InputClass\"
	Identifier \"Touchpads\"
	Driver \"libinput\"
	MatchIsTouchpad \"on\"
	Option \"Tapping\" \"on\"
	Option \"DisableWhileTyping\" \"on\"
	Option \"MiddleEmulation\" \"on\"
	Option \"ClickMethod\" \"clickfinger\"
	Option \"NaturalScrolling\" \"true\"
	Option \"ScrollMethod\" \"twofinger\"
EndSection
Section \"InputClass\"
	Identifier \"Keyboards\"
	Driver \"libinput\"
	MatchIsKeyboard \"on\"
EndSection")

(define (my-services)
     (append
    (list
     (service gnome-desktop-service-type)
     (set-xorg-configuration
      (xorg-configuration
       (drivers '("modesetting"))
       (keyboard-layout keyboard-layout)
       (extra-config
        (list %xorg-libinput-config))))
     (service tlp-service-type
        (tlp-configuration
         (cpu-boost-on-ac? #t)
         (wifi-pwr-on-bat? #t)))
     (service nftables-service-type))))
   
(operating-system
  ;; Use a linux kernel since this laptop doesn't support GNU Hurd
  ;; (kernel linux)
  (kernel
   (package
     (inherit linux)
     (name "linux-nonfree")
     (native-inputs
      `(("kconfig" ,(local-file
                     (string-append
                      (dirname
                       (current-filename))
                      "/kernel-"
                      (version-major+minor kernel-version)
                      ".config")
                     ))
        ,@(alist-delete "kconfig"
                        (package-native-inputs linux))))))
  (kernel-arguments
   '("quiet"
     "audit=0"
     "selinux=0"
     ;; Do not disable mitigrations
     ;; "mitigations=off"
     "i915.enable_guc=2"
     "i915.enable_fbc=1"
     "i915.enable_dc=1"
     ;;"ipv6.disable=1" - Enable IPv6 again, required for Rust build testing
     ;; intel_pstate causes throttling of the CPU with a bad charger, and
     ;; refuses to go to Turbo of 4.2Ghz, stays at maybe 1.2Ghz
     ;;
     ;; By disabling intel_pstate driver, it will resort to the old acpi_cpufreq
     ;; driver, that performs cpu scaling in software and consumes more power
     ;; but it doesn't throttle automatically with a bad charger.
     "intel_pstate=disable"
     ;; Hibernate initramfs hook not implemented in Guix yet, disable for now.
     ;; see: https://issues.guix.gnu.org/issue/37290
     ;;"resume=/dev/nvme0n1p3"

     ;; boot fails to find UUID, loop on "waiting for partition with UUID" during boot.
     ;; sudo findmnt -no UUID -T /swap/swapfile
     ;;"resume=UUID=21db4581-dd6c-4180-9325-f1d9e9f99c5d"
     ;; sudo filefrag -v /swap/swapfile, first column of physical_offset
     ;;"resume_offset=29106289"
     ))
  (initrd microcode-initrd)
  (initrd-modules
   ;; The point where you learn Guile properly...
   ;;(lset-difference eqv? %base-initrd-modules '("framebuffer_coreboot") '("pata_acpi")))
   ;;(delete ("framebuffer_coreboot" "pata_acpi" "pata_atiixp") %base-initrd-modules))
   (delete "framebuffer_coreboot"
           ;; pata_acpi is not in this kernel version
           (delete "pata_acpi"
                   (delete "pata_atiixp" %base-initrd-modules))))
  (firmware
   (list linux-firmware sof-firmware iwlwifi-firmware))
  (locale "en_US.utf8")
  (timezone "Europe/Stockholm")
  (keyboard-layout
   (keyboard-layout "se"))
  (host-name "devbox")
  (users
   (cons*
    (user-account
     (name "noname")
     (comment "Paul Alesius")
     (group "users")
     (home-directory "/home/noname")
     (supplementary-groups
      '("wheel"
        "netdev"
        "audio"
        "video"
        "libvirt" ;; only when there's a libvirtd service
        "input")))
    %base-user-accounts))
  (packages
   (append
    (list emacs-exwm-managed)
   (map (compose list specification->package+output)
        (list "emacs-pgtk-native-comp"
              ;;"emacs-native-comp"
              ;;"emacs-exwm-managed"
              ;;"emacs-desktop-environment"
              "emacs-guix"
              ;;"emacs-pinentry"
              ;;"guile-colorized"
              ;;"guile-readline"
              "nss-certs"
              "wireguard-tools"
              "cryptsetup"
              "btrfs-progs"
              "brightnessctl"
              "xf86-input-libinput"
              "tlp"
              "bridge-utils"))
   %base-packages))
   ;;(append
   ;; (list
     ;;(specification->package "emacs")
   ;;  (specification->package "emacs-pgtk-native-comp")
   ;;  (specification->package "emacs-exwm")
   ;;  (specification->package "emacs-desktop-environment")
   ;;  (specification->package "emacs-guix")
   ;;  (specification->package "nss-certs")
   ;;  (specification->package "wireguard-tools")
   ;;  (specification->package "xf86-input-libinput")
   ;;  (specification->package "tlp"))
   ;; %base-packages))
  (services
   (append
    (list
     (service gnome-desktop-service-type)
     (set-xorg-configuration
      (xorg-configuration
       (drivers '("modesetting"))
       (keyboard-layout keyboard-layout)
       (extra-config
        (list %xorg-libinput-config))))
     (screen-locker-service xlockmore "xlock")
     (service tlp-service-type
        (tlp-configuration
         (cpu-boost-on-ac? #t)
         (wifi-pwr-on-bat? #t)))
     (service nftables-service-type
        (nftables-configuration
         (ruleset (local-file (string-append (dirname (current-filename)) "/nftables.nft")))))
     (service libvirt-service-type
              (libvirt-configuration
               ;; Allow users of this group to access privileged use, defaults to root but use libvirt group
               (unix-sock-group "libvirt")))
     (service virtlog-service-type
              (virtlog-configuration
               (max-clients 8))))
     ;; Build failure, add once thermald is updated
     ;; src/thd_engine_adaptive.cpp:1002:61: error: ‘gboolean up_client_get_lid_is_closed(UpClient*)’ is deprecated [-Werror=deprecated-declarations]
     ;; 1002 |  bool lid_closed = up_client_get_lid_is_closed(upower_client);
	 ;;(service thermald-service-type)
    (modify-services %desktop-services
        ;; This destroys my desktop and gdm doesn't start for me. I don't understand how dependencies are included
        ;; and excluded.
        ;;(filter
        ;;   (lambda (service)
        ;;     (cond
        ;;      ((string= (symbol->string (service-type-name (service-kind service))) "sane") #false)
        ;;      ((string= (symbol->string (service-type-name (service-kind service))) "mount-setuid-helpers") #false)
        ;;      ((string= (symbol->string (service-type-name (service-kind service))) "network-manager-applet") #false)
        ;;      ((string= (symbol->string (service-type-name (service-kind service))) "modem-manager") #false)
        ;;      ((string= (symbol->string (service-type-name (service-kind service))) "avahi") #false)
        ;;      ((string= (symbol->string (service-type-name (service-kind service))) "accountsservice") #false)
        ;;      ((string= (symbol->string (service-type-name (service-kind service))) "cups-pk-helper") #false)
        ;;      ((string= (symbol->string (service-type-name (service-kind service))) "geoclue") #false)
        ;;      (else #true)
        ;;      ))
        ;;   %desktop-services)
      (elogind-service-type config =>
        (elogind-configuration
        ;; change to 'hibernate once hibernate is implemented in Guix initramfs
        ;; see kernel param
        (handle-lid-switch 'suspend)))
      (gdm-service-type config =>
        (gdm-configuration (inherit config)
        (default-user "noname")))
        ;; (auto-login? #t) ; claims to break GDM, test it later https://notabug.org/Ambrevar/dotfiles/src/master/.config/guix/system/desktop-fafafa.scm
      (guix-service-type config =>
        (guix-configuration (inherit config)
                            (tmpdir "/var/tmp"))))))
  (bootloader
   (bootloader-configuration
    (bootloader grub-efi-bootloader)
    ;; Setting timeout to 0 doesn't seem to work, it boots directly instead of waiting indefinitely
    (timeout 5)
    (targets
     (list "/boot"))
    (keyboard-layout keyboard-layout)))
  (mapped-devices
   ;; LUKS2 devices must use PKBDF2 key-derivation function, because grub2 luks2 cryptomount module
   ;; does not support argon2 yet. Cryptsetup can convert the key function from argon2 to PKBDF2
   ;;
   ;; Set a low iteration count because the GRUB2 pbkdf2 implementation is extremely slow
   ;; cryptsetup luksFormat --type luks2
   ;;                       --pbkdf pbkdf2
   ;;                       --iter-time 500
   ;;                       --hash 256
   ;;                       --key-size 256
   ;;                       --sector-size 4096 # Use 4K sectors
   ;;                       ...
   (list
    (mapped-device
     (source (uuid "21db4581-dd6c-4180-9325-f1d9e9f99c5d"))
     (target "storage")
     (type luks-device-mapping))))
  (file-systems
   (cons*
    (file-system
      (mount-point "/")
      (device "/dev/mapper/storage")
      (flags '(no-atime))
      (options "subvol=guix-root,compress=zstd")
      (type "btrfs")
      (dependencies mapped-devices))
    (file-system
      (mount-point "/swap")
      (device "/dev/mapper/storage")
      (flags
       '(no-atime))
      (options "subvol=swap")
      (type "btrfs")
      (dependencies mapped-devices))
    (file-system
      (mount-point "/storage")
      (device "/dev/mapper/storage")
      (flags
       '(no-atime))
      (type "btrfs")
      (dependencies mapped-devices))
    (file-system
      (mount-point "/boot")
      (device
       (uuid "7504-519B" 'fat32))
      (type "vfat"))
    (file-system
      (mount-point "/tmp")
      (device "none")
      (type "tmpfs")
      (check? #f))
    %base-file-systems))
  ;; Looks like it works to depend on file-systeme, but it needs to be declared after
  ;; the file-systems declaration as it looks like a variable
  ;;
  ;; btrfs subvolume create swap
  ;; mount -o subvol=swap /dev/mapper/storage /swap
  ;; truncate -s 0 /swap/swapfile
  ;; chattr +C /swap/swapfile
  ;; btrfs property set /swap/swapfile compression none
  ;; # Allocate three times the RAM, so that large builds such as webkit don't run out
  ;; # while having other programs open.
  ;; fallocate -l $[$(free -b | awk 'NR == 2 {print $2}')] /swap/swapfile
  ;; chmod 600 /swap/swapfile
  (swap-devices
   (list
    (swap-space
     (target "/swap/swapfile")
     (dependencies file-systems)))))
