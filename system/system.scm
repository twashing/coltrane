(use-modules (gnu)
             (gnu image)
             (gnu system image)
             (nongnu packages linux)
             (guix profiles)
             (guix packages)
             (guix scripts package)
             (ice-9 binary-ports)
             (miles packages fonts))

(use-service-modules
  cups
  desktop
  networking
  ssh
  xorg
  docker)

(define physical-operating-system
  (operating-system
   (kernel linux)
   (firmware (list linux-firmware))
   (locale "en_US.utf8")
   (timezone "America/New_York")
   (keyboard-layout (keyboard-layout "us"))
   (host-name "guix")
   (users (cons* (user-account
                  (name "twashing")
                  (comment "twashing")
                  (group "users")
                  (home-directory "/home/twashing")
                  (supplementary-groups
                   '("wheel" "netdev" "audio" "video")))
                 %base-user-accounts))
   (packages
    (append
     (map specification->package
          '("gcc-toolchain"
            "make"
            "git"
            "emacs" "vim"
            "tree"
            "stow"
            "zip" "unzip"
            "wget" "curl"

            ;; NOTE
            ;; https://github.com/junegunn/fzf
            ;; https://junegunn.github.io/fzf
            ;; https://www.youtube.com/watch?v=oTNRvnQLLLs

            ;; TODO
            ;; configure terminal colors with fzf output (in Ghostty)
            "fzf" "bat"
            "fd"
            "python-tldr"
            "zoxide"

            "the-silver-searcher"
            "ripgrep"
            "font-pragmata-pro-liga"
            "font-iosevka"

            ;; The `containerd-service-type` manages the installation and configuration of `containerd`
            ;; so we don't need to include it separately in the `packages` list
            ;; "containerd"
            "docker"
            "docker-cli"

            "netcat"
            "nmap"

            "sshfs"
            "rclone"
            "openssl"
            "gnupg"
            "openvpn"
            "network-manager-openvpn"
            "ghostty"
            "ungoogled-chromium"))
     %base-packages))
   (services
    (append
     (list

      ;; (service guix-service-type
      ;;          (guix-configuration
      ;;           (inherit (guix-configuration))
      ;;           (authorized-keys
      ;;            (cons* (local-file "/home/twashing/default-public-key.asc")
      ;;                   (guix-configuration-authorized-keys (guix-configuration)))))
      ;; 
      ;;          ;; (guix-configuration
      ;;          ;;  (authorized-keys
      ;;          ;;   (list (local-file "/home/twashing/default-public-key.asc"))))
      ;;          )
      
      (service gnome-desktop-service-type)
      (service xfce-desktop-service-type)
      (service openssh-service-type)
      (service tor-service-type)
      (set-xorg-configuration
       (xorg-configuration
        (keyboard-layout keyboard-layout)))
      (service containerd-service-type
               (containerd-configuration
                ;; You can specify additional configuration here if needed
                ))
      (service docker-service-type
               (docker-configuration
                (debug? #t)                     ; Enable debug logging (optional)
                ;; (hosts '("unix:///var/run/docker.sock"))  ; Specify the socket
                ;; Add more configuration options as needed
                )))
     ;; %desktop-services
     (modify-services %desktop-services
                      (guix-service-type config =>
                                         (guix-configuration
                                          (inherit config)

                                          ;; (authorized-keys
                                          ;;  (cons* (local-file "/home/twashing/default-public-key.gpg")
                                          ;;         (guix-configuration-authorized-keys config)))

                                          ;; (authorized-keys
                                          ;;  (cons* (plain-file "default-public-key.gpg"
                                          ;;                     (call-with-input-file 
                                          ;;                         "/home/twashing/default-public-key.gpg"
                                          ;;                       get-bytevector-all))
                                          ;;         (guix-configuration-authorized-keys config)))

                                          ;; (authorized-keys
                                          ;;  (cons* "/home/twashing/default-public-key.gpg"
                                          ;;         (guix-configuration-authorized-keys config)))

                                          ;; (authorized-keys
                                          ;;  (cons
                                          ;;   (computed-file "default-public-key.gpg"
                                          ;;                  #~(begin
                                          ;;                      (use-modules (ice-9 binary-ports))
                                          ;;                      (define content
                                          ;;                        (call-with-input-file
                                          ;;                            "/home/twashing/default-public-key.gpg"
                                          ;;                          get-bytevector-all))
                                          ;;                      (call-with-output-file #$output
                                          ;;                        (lambda (port)
                                          ;;                          (put-bytevector port content)))))
                                          ;;   (guix-configuration-authorized-keys config)))
                                          )))
     ))
   (bootloader
    (bootloader-configuration
     (bootloader grub-efi-bootloader)
     (targets (list "/boot/efi"))
     (keyboard-layout keyboard-layout)))
   (swap-devices
    (list (swap-space
           (target
            (uuid "e5f1a4a1-f2fd-4e7e-8ec7-05abcd4d70f3")))))
   (file-systems
    (cons* (file-system
            (mount-point "/boot/efi")
            (device (uuid "E6AE-7A56" 'fat32))
            (type "vfat"))
           (file-system
            (mount-point "/")
            (device
             (uuid "e67e1014-9dfe-4b14-a113-ce9c56f963bf"
                   'ext4))
            (type "ext4"))
           %base-file-systems))))

physical-operating-system
