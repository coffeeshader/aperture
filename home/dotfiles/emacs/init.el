;;;; Package management
(if (or (file-exists-p "/etc/gentoo-release")
        (file-exists-p "/etc/NIXOS"))
    (setq use-package-always-ensure nil)
  (setq use-package-always-ensure t))

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)
(require 'use-package)

(setopt native-comp-async-report-warnings-errors 'silent
        package-install-upgrade-built-in t
        package-native-compile t)

;;;; UI / Theme

(use-package dashboard
  :config
  (setq dashboard-banner-logo-title "Welcome to Emacs!"
        dashboard-startup-banner 'logo
        dashboard-center-content t
        dashboard-projects-backend 'project-el
        dashboard-items '((projects  . 8)
                          (bookmarks . 8)
                          (recents   . 5)))
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

;;;; Indentation
(setq-default indent-tabs-mode nil
              tab-always-indent 'complete
              c-default-style "bsd"
              c-basic-offset 4)

;;;; Images
(add-hook
 'image-mode-hook
 (lambda ()
   (face-remap-add-relative 'default :background "white")))

;;;; Language Modes / LSP / Code editing stuff

(use-package eglot
  :hook ((rust-ts-mode
          java-ts-mode
          zig-mode
          python-mode
          c-mode
          nix-mode
          ) . eglot-ensure)
  :config
  (setq eglot-autoshutdown t
        eglot-events-buffer-config '(:size 0 :format short)
        eglot-ignored-server-capabilities '(:documentFormattingProvider
                                            :documentOnTypeFormattingProvider
                                            :documentRangeFormattingProvider)
        eglot-code-action-indicator ""))

(use-package compile
  :defer t
  :config
  (setopt compilation-ask-about-save nil
          compilation-scroll-output t
          compilation-auto-jump-to-first-error t
          compilation-max-output-line-length nil
          compile-command ""))

(require 'ansi-color)
(add-hook 'compilation-filter-hook #'ansi-color-compilation-filter)

(add-hook 'compilation-mode-hook
          (lambda () (setq-local process-connection-type nil)))

(use-package flymake
  :defer t
  :config
  (setopt flymake-margin-indicators-string '((error "x" compilation-error)
                                             (warning "!" compilation-warning)
                                             (note "!" compilation-info))))

(use-package company
  :hook (prog-mode . company-mode))

(use-package rust-mode
  :init
  (setq rust-mode-treesitter-derive t))

(use-package zig-mode)

(use-package nix-mode
  :mode "\\.nix\\'")

(add-to-list 'major-mode-remap-alist '(java-mode . java-ts-mode))
(add-to-list 'major-mode-remap-alist '(rust-mode . rust-ts-mode))

;;;; org-mode

(use-package org
  :defer t
  :config
  (setq org-element-use-cache t
        org-element-cache-persistent t
        org-directory "~/Notes"
        org-return-follows-link t
        org-hide-emphasis-markers t
        org-startup-indented t
        org-startup-with-inline-images t
        org-startup-folded 'overview
        org-edit-src-content-indentation 0
        org-yank-image-save-method "images"))

(use-package org-roam
  :defer t
  :init
  (setq org-roam-directory (file-truename "~/Notes")
        org-roam-db-location
        (expand-file-name "emacs/org-roam.db"
                          (or (getenv "XDG_CACHE_HOME") "~/.cache")))
  (make-directory org-roam-directory t)

  :config
  (setq org-roam-completion-everywhere t)
  (org-roam-db-autosync-mode))

(use-package org-roam-ui
  :after org-roam
  :config
  (setq org-roam-ui-sync-theme t
        org-roam-ui-follow t
        org-roam-ui-update-on-save t))

(defun my/org-roam-ui-toggle ()
  "Start org-roam-ui and open the browser, or shut the server down."
  (interactive)
  (if (bound-and-true-p org-roam-ui-mode)
      (org-roam-ui-mode -1)
    (org-roam-ui-open)))

(use-package org-modern
  :hook (org-mode . org-modern-mode))

(use-package org-appear
  :hook (org-mode . org-appear-mode))

;;;; Keybindings

(use-package evil
  :init
  (setq evil-want-keybinding nil
        evil-want-integration t)
  :config
  (evil-mode 1))

(use-package evil-surround
  :config
  (global-evil-surround-mode 1))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init '(compile company dired eglot org-roam magit dashboard)))

(use-package evil-org
  :after org
  :hook (org-mode . evil-org-mode)
  :config
  (require 'evil-org-agenda)
  (evil-org-agenda-set-keys))

(define-key minibuffer-local-completion-map
            (kbd "SPC")
            #'self-insert-command)

(evil-define-key 'normal 'global
  (kbd "zx")      #'kill-current-buffer
  (kbd "SPC b")   #'switch-to-buffer
  (kbd "SPC .")   #'find-file

  (kbd "SPC c c") #'compile
  (kbd "SPC c r") #'recompile

  (kbd "SPC m s") #'bookmark-set
  (kbd "SPC m d") #'bookmark-delete
  (kbd "SPC m l") #'list-bookmarks

  (kbd "SPC p f") #'project-find-file
  (kbd "SPC p p") #'project-switch-project
  (kbd "SPC p k") #'project-kill-buffers
  (kbd "SPC p c") #'project-compile

  (kbd "SPC g g") #'magit-status
  (kbd "SPC g s") #'git-commit-signoff

  (kbd "SPC d")   #'dashboard-open

  (kbd "SPC n f") #'org-roam-node-find
  (kbd "SPC n i") #'org-roam-node-insert
  (kbd "SPC n b") #'org-roam-buffer-toggle
  (kbd "SPC n c") #'org-roam-capture
  (kbd "SPC n p") #'yank-media
  (kbd "SPC n t") #'org-roam-tag-add
  (kbd "SPC n a") #'org-roam-alias-add
  (kbd "SPC n l") #'org-store-link
  (kbd "SPC n g") #'my/org-roam-ui-toggle

  (kbd "SPC w w") #'whitespace-mode
  (kbd "SPC w c") #'whitespace-cleanup)

(evil-define-key 'visual 'global
  (kbd "TAB") #'indent-region
  (kbd "gc")  #'comment-or-uncomment-region)

(evil-define-key 'normal eglot-mode-map
  (kbd "SPC l r") #'eglot-rename
  (kbd "SPC l a") #'eglot-code-actions)

(evil-define-key 'normal markdown-mode-map
  (kbd "gf") #'markdown-follow-thing-at-point)

(evil-define-key 'normal org-mode-map
  (kbd "SPC n v") #'org-toggle-inline-images)

;;;; Save information across sessions
(save-place-mode t)

;;;; etc
;;;; TODO: CLEANUP
(setopt custom-file "~/.config/emacs/custom.el"
        use-short-answers t
        confirm-kill-processes nil
        electric-pair-mode t
        view-read-only t
        make-backup-files nil)

(setq-default create-lockfiles nil
              backup-inhibited t
              delete-auto-save-files t
              auto-save-mode nil
              auto-save-default nil)

(load-file custom-file)

;; buffer-local direnv environments; must be enabled late in init
(use-package envrc
  :config
  (envrc-global-mode))

(provide 'init)
