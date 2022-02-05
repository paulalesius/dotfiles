;; This is an operating system configuration generated
;; by the graphical installer.

(use-modules (gnu)
	         (gnu services pm)
	         (gnu packages display-managers)
	         (nongnu packages linux)
	         (nongnu system linux-initrd))
(use-service-modules
  desktop
  networking
  ssh
  xorg
  vpn)
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

(operating-system
   (kernel linux)
   (kernel-arguments '("quiet"
                       "audit=0"
                       "selinux=0"
                       "mitigations=off"
                       "i915.enable_guc=2"
                       "i915.enable_fbc=1"
                       "i915.enable_dc=1"
                       ;; Required so that we use the IPv4 route through Wireguard
                       ;; until we have a firewall to block non-vpn connections.
                       "ipv6.disable=1"
                       "intel_pstate=disable"
                       ;; Hibernate initramfs hook not implemented in Guix yet, disable for now.
                       ;; see: https://issues.guix.gnu.org/issue/37290
                       ;;"resume=/dev/nvme0n1p3"
                       ))
  (initrd microcode-initrd)
  (firmware (list linux-firmware sof-firmware))
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
	    (specification->package "vim")
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
                        c => (elogind-configuration
                              ;; change to 'hibernate once hibernate is implemented in Guix initramfs
                              ;; see kernel param
                              (handle-lid-switch 'suspend))))))
  (bootloader
    (bootloader-configuration
      (bootloader grub-efi-bootloader)
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
	     (options "subvol=guix-root")
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
           %base-file-systems)))

