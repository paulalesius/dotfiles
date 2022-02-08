
(use-modules (srfi srfi-1)
             (gnu)
	         (gnu services pm)
             (guix packages)
             (guix download)
             (guix git-download)
             (guix utils)
	         (gnu packages display-managers)
             (gnu packages linux)
	         (nongnu packages linux)
	         (nongnu system linux-initrd))
(use-service-modules
  desktop       ;; GNOME-based desktop services, gdm, NetworkManager, etc.
  networking    ;; ??
  ssh           ;; ??
  xorg          ;; Included in desktop? Probably for emacs
  vpn           ;; wireguard??
)
(use-package-modules certs)

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

(define kernel-version
  "5.16.7")

(define kernel-hash
  "1kd6v31z9rylnpyrv6b3i622ismxbiv165dcjh2fn5aliqzgalap")

;; This method is overridden from gnu/packages/linux to change the URL
(define (linux-urls version)
  "Return a list of URLS for Linux VERSION."
  (list (string-append "https://www.kernel.org/pub/linux/kernel/v"
                       (version-major version) ".x/linux-" version ".tar.xz")))

;; Override to the latest minor version and source hash (guix hash)
(define-public linux-5.16
    (corrupt-linux linux-libre-5.16 kernel-version kernel-hash))

;; Overrides framework version that defaults to linux-5.15
(define-public linux linux-5.16)

(operating-system
  ;; Use a linux kernel since this laptop doesn't support GNU Hurd
  ;; (kernel linux)
  (kernel (package
           (inherit linux)
           (name "linux-nonfree")
   (native-inputs
    `(("kconfig" ,(local-file (string-append "kernel-" (version-major+minor kernel-version) ".config")   ))
       ,@(alist-delete "kconfig" (package-native-inputs linux))))))

  (kernel-arguments '("quiet"
                       "audit=0"
                       "selinux=0"
                       ;; Do not disable mitigrations
                       ;; "mitigations=off"
                       "i915.enable_guc=2"
                       "i915.enable_fbc=1"
                       "i915.enable_dc=1"
                       ;; Required so that we use the IPv4 route through Wireguard
                       ;; until we have a firewall to block non-vpn connections.
                       "ipv6.disable=1"
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
                       ))
  (initrd microcode-initrd)
  (initrd-modules (delete "framebuffer_coreboot" %base-initrd-modules))
  (firmware (list linux-firmware sof-firmware iwlwifi-firmware))
  (locale "en_US.utf8")
  (timezone "Europe/Stockholm")
  (keyboard-layout (keyboard-layout "se"))
  (host-name "devbox")
  (users (cons* (user-account
                  (name "noname")
                  (comment "Paul Alesius")
                  (group "users")
                  (home-directory "/home/noname")
                  (supplementary-groups
                   '("wheel"
                     "netdev"
                     "audio"
                     "video"
                     "input"
                    )))
                %base-user-accounts))

  (packages
    (append
      (list (specification->package "emacs")
            (specification->package "emacs-exwm")
            (specification->package
              "emacs-desktop-environment")
            (specification->package "nss-certs")
	    (specification->package "wireguard-tools")
	    (specification->package "xf86-input-libinput")
	    (specification->package "tlp"))
      %base-packages))
  (services
    (append
      (list (service gnome-desktop-service-type)
            (set-xorg-configuration
            	(xorg-configuration
	    	(drivers '("modesetting"))
            	(keyboard-layout keyboard-layout)
	    	(extra-config (list
	    		           %xorg-libinput-config))))
	(service tlp-service-type
		 (tlp-configuration
		   (cpu-boost-on-ac? #t)
		   (wifi-pwr-on-bat? #t)))
	(service thermald-service-type))
    (modify-services %desktop-services
            (elogind-service-type
                config => (elogind-configuration
                              ;; change to 'hibernate once hibernate is implemented in Guix initramfs
                              ;; see kernel param
                      (handle-lid-switch 'suspend)))
            (gdm-service-type config =>
                              (gdm-configuration
                               (inherit config)
                               (default-user "noname")
                               ;; (auto-login? #t) ; claims to break GDM, test it later https://notabug.org/Ambrevar/dotfiles/src/master/.config/guix/system/desktop-fafafa.scm
                               ))
            (guix-service-type config =>
                               (guix-configuration
                                (inherit config)
                                (tmpdir "/var/tmp")))
            )))
  (bootloader
    (bootloader-configuration
     (bootloader grub-efi-bootloader)
     ;; Setting timeout to 0 doesn't seem to work, it boots directly instead of waiting indefinitely
     (timeout 5)
     (targets (list "/boot"))
     (keyboard-layout keyboard-layout)))
  (mapped-devices
   ;; LUKS2 devices must use PKBDF2 key-derivation function, because grub2 luks2 cryptomount module
   ;; does not support argon2 yet. Cryptsetup can convert the key function from argon2 to PKBDF2
   ;;
   ;; Set a low iteration count because the GRUB2 pbkdf2 implementation is extremely slow
   ;; cryptsetup luksFormat --iter-time 500 --hash 256 --key-size 256 --sector-size 4096 ...
    (list (mapped-device
           (source
              (uuid "21db4581-dd6c-4180-9325-f1d9e9f99c5d"))
            (target "storage")
            (type luks-device-mapping))
    (mapped-device
     (source
        (uuid "8012bc63-cad6-4542-a9bb-a6c998646459"))
     (target "swap")
     (type luks-device-mapping))))
  (swap-devices (list
		 (swap-space
		  ;;(target (uuid "f8fadc31-c1fc-46e4-931e-17623ac06411"))
		  (target "/dev/mapper/swap")
		  (dependencies mapped-devices))))
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
     (mount-point "/storage")
     (device "/dev/mapper/storage")
     (flags '(no-atime))
     (type "btrfs")
     (dependencies mapped-devices))
           (file-system
             (mount-point "/boot")
             (device (uuid "7504-519B" 'fat32))
             (type "vfat"))
  (file-system
    (mount-point "/tmp")
    (device "none")
    (type "tmpfs")
    (check? #f))
  %base-file-systems)))
