(use-modules (gnu home)
             (gnu home services)
             (gnu home services gnupg)
             (gnu home services ssh)
             (gnu home services syncthing)
             (gnu packages emacs)
             (gnu packages gnupg)
             (gnu packages ssh)
             (gnu packages syncthing)
             (guix gexp))

(home-environment

 (packages
  (list gnupg       ; GnuPG for encryption and signing
        ;; openssh     ; SSH tools (client and optionally server)
        ;; syncthing   ; Syncthing for file synchronization
        ;; pinentry-emacs
        ))

 (services
  (list

   (service home-gpg-agent-service-type
             (home-gpg-agent-configuration

              ;; Point to the Emacs-based pinentry program
              (pinentry-program
               (file-append pinentry "/bin/pinentry-curses"))
              (ssh-support? #t)))

   ;; (service home-gpg-agent-service-type
   ;;       (home-gpg-agent-configuration
   ;;        (pinentry-program
   ;;         (file-append pinentry-curses "/run/current-system/profile/bin/pinentry"))
   ;;        (ssh-support? #t)))

   ;; (service home-gnupg-service-type
   ;;          (home-gnupg-configuration
   ;;           (gpg gnupg)
   ;;
   ;;           ;; Enable SSH support through the GPG agent:
   ;;           (enable-ssh-support? #t)))

   ;; (service home-openssh-service-type
   ;;          (home-openssh-configuration
   ;;
   ;;           ;; Example ssh-config. Adjust to your needs.
   ;;           (ssh-config
   ;;            (plain-file "ssh-config"
   ;;                        "Host example
   ;;                            HostName example.com
   ;;                            User alice
   ;;                            IdentityFile ~/.ssh/id_ed25519"))))

   ;; (service home-syncthing-service-type
   ;;          (home-syncthing-configuration
   ;;
   ;;           ;; Provide the Syncthing package
   ;;           (syncthing syncthing)
   ;;
   ;;           ;; Default location for Syncthing’s runtime data
   ;;           (data-directory \"~/.local/share/syncthing\")))
   )))
