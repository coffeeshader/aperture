;; Remove unwanted/unneeded UI elements

(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)

(setopt inhibit-startup-screen t
        initial-scratch-message nil
        use-dialog-box nil
        use-file-dialog nil)

;; Faster runtime

(setq read-process-output-max (* 4 1024 1024))

;; Faster startup
(defvar old-file-name-handler file-name-handler-alist)

(setq file-name-handler-alist nil
      gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.8)

(add-hook 'emacs-startup-hook
          (lambda ()
            (setq file-name-handler-alist old-file-name-handler
                  gc-cons-threshold (* 64 1024 1024)
                  gc-cons-percentage 0.1)))

(provide 'early-init)
