;;; -*- lexical-binding: t; -*-

;;;; Indentation
(setq-default indent-tabs-mode nil
              tab-always-indent 'complete)

;;;; Save information across sessions
(save-place-mode t)

(use-package recentf
  :defer t
  :config
  (add-to-list 'recentf-exclude
               (lambda (file)
                 (and (not (file-remote-p file))
                      (file-in-directory-p file "~/Notes")))))

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

(provide 'aperture-defaults)
