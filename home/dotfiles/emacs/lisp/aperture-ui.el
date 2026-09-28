;;; -*- lexical-binding: t; -*-

;;;; UI / Theme

(use-package dashboard
  :config
  (setq dashboard-banner-logo-title "This was a triumph. I'm making a note here: HUGE SUCCESS."
        dashboard-startup-banner (locate-user-emacs-file "aperture.svg")
        dashboard-center-content t
        dashboard-projects-backend 'project-el
        dashboard-items '((projects  . 6)
                          (bookmarks . 5)
                          (recents   . 6)
                          (agenda    . 7))
        dashboard-agenda-prefix-format " %i %(my/org-agenda-title) %s ")
  ;; emacsclient frames (no file args) open on the dashboard too
  (setq initial-buffer-choice (lambda () (get-buffer-create dashboard-buffer-name)))
  (dashboard-setup-startup-hook))

(global-so-long-mode 1)

(add-hook 'prog-mode-hook #'display-line-numbers-mode)
(add-hook 'text-mode-hook #'visual-line-mode)

(setq-default display-line-numbers-type 'relative
              whitespace-style '(face trailing tabs spaces space-mark tab-mark missing-newline-at-eof))

(use-package catppuccin-theme
  :config
  (load (locate-user-emacs-file "theme") 'noerror)
  (load-theme 'catppuccin :no-confirm))

(use-package ligature
  :config
  (ligature-set-ligatures t '("->" "=>"))
  (global-ligature-mode 1))

(use-package nerd-icons
  :custom (nerd-icons-font-family "Symbols Nerd Font Mono")
  :config
  (pcase-dolist (`(,name . ,color)
                 '((red . red) (maroon . maroon) (orange . peach) (yellow . yellow)
                   (green . green) (cyan . teal) (blue . blue) (purple . mauve)
                   (pink . pink) (silver . overlay2)))
    (dolist (prefix '("" "l" "d"))
      (dolist (suffix '("" "-alt"))
        (let ((face (intern (format "nerd-icons-%s%s%s" prefix name suffix))))
          (when (facep face)
            (set-face-attribute face nil
                                :foreground (catppuccin-get-color color))))))))

(use-package doom-modeline
  :custom
  (doom-modeline-height 28)
  (doom-modeline-bar-width 4)
  (doom-modeline-buffer-file-name-style 'truncate-with-project)
  (doom-modeline-major-mode-icon t)
  (doom-modeline-buffer-encoding t)
  (doom-modeline-lsp t)
  (doom-modeline-modal t)
  (doom-modeline-modal-icon t)
  (doom-modeline-modal-modern-icon t)
  (doom-modeline-check-simple-format nil)
  :config
  (let ((accent (catppuccin-get-color 'mauve)))
    (set-face-attribute 'doom-modeline-project-dir nil :foreground accent :inherit 'bold)
    (set-face-attribute 'doom-modeline-bar nil :background accent))
  (set-face-attribute 'doom-modeline-meow-normal-state nil
                      :foreground (catppuccin-get-color 'blue))
  (set-face-attribute 'doom-modeline-vcs-default nil
                      :foreground (catppuccin-get-color 'mauve))
  (define-advice doom-modeline-vcs-icon (:filter-args (args) aperture-recolor)
    "Draw the git icon in the branch name's face instead of `doom-modeline-info'."
    (pcase-let ((`(,icon ,unicode ,text ,face ,icon-set) args))
      (list icon unicode text
            (if (eq face 'doom-modeline-info) 'doom-modeline-vcs-default face)
            icon-set)))
  (doom-modeline-mode 1))

;;;; Images
(add-hook
 'image-mode-hook
 (lambda ()
   (face-remap-add-relative 'default :background "white")))

(provide 'aperture-ui)
