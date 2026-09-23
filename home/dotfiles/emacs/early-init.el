;;; -*- lexical-binding: t; -*-

;; Remove unwanted/unneeded UI elements

(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)

(setopt inhibit-startup-screen t
        initial-scratch-message nil
        use-dialog-box nil
        use-file-dialog nil)

;; Accept pixel-exact frame sizes
(setq frame-resize-pixelwise t)

;; Faster runtime

(setq read-process-output-max (* 4 1024 1024))

(setq bidi-inhibit-bpa t)
(setq-default bidi-paragraph-direction 'left-to-right)

;; Faster startup
(defvar old-file-name-handler file-name-handler-alist)

(setq file-name-handler-alist nil)

(add-hook 'emacs-startup-hook
          (lambda ()
            (setq file-name-handler-alist old-file-name-handler)))

(provide 'early-init)
