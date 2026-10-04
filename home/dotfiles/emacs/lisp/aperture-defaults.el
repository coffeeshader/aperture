;;; -*- lexical-binding: t; -*-

;;;; Indentation
(setq-default indent-tabs-mode nil
              tab-always-indent 'complete)

;;;; Save information across sessions
(save-place-mode t)

(global-auto-revert-mode t)

(use-package recentf
  :defer t
  :config
  (add-to-list 'recentf-exclude
               (lambda (file)
                 (and (not (file-remote-p file))
                      (file-in-directory-p file "~/Notes")))))

;;;; etc
(setopt custom-file (expand-file-name "emacs/custom.el"
                                      (or (getenv "XDG_CACHE_HOME") "~/.cache")))

(setopt use-short-answers t
        confirm-kill-processes nil
        electric-pair-mode t
        repeat-mode t
        view-read-only t
        make-backup-files nil)

(setq-default create-lockfiles nil
              auto-save-default nil)

(provide 'aperture-defaults)
