;;; -*- lexical-binding: t; -*-

;;;; org-mode

(defun my/org-agenda-title ()
  "Note title for agenda lines, padded to a fixed width."
  (truncate-string-to-width
   (or (and (derived-mode-p 'org-mode)
            (or (org-get-title) (org-get-category)))
       "")
   12 nil ?\s))

(use-package org
  :defer t
  :commands (org-store-link org-link-preview
             org-time-stamp org-time-stamp-inactive org-schedule org-deadline)
  :config
  (setq org-element-cache-persistent t
        org-directory "~/Notes"
        org-return-follows-link t
        org-hide-emphasis-markers t
        org-startup-indented t
        org-startup-with-link-previews t
        org-startup-folded 'overview
        org-edit-src-content-indentation 0
        org-yank-image-save-method "images")

  (setq org-todo-keywords
        '((sequence "TODO(t)" "NEXT(n)" "WAIT(w@)" "|" "DONE(d)" "CANCELLED(c@)"))
        org-log-done 'time
        org-log-into-drawer t)

  (setq org-agenda-files '("~/Notes" "~/Notes/daily")
        org-agenda-skip-unavailable-files t
        org-agenda-span 'week
        org-agenda-start-on-weekday 1
        org-agenda-skip-scheduled-if-done t
        org-agenda-skip-deadline-if-done t
        org-deadline-warning-days 7
        org-agenda-prefix-format
        '((agenda . " %i %(my/org-agenda-title) %?-12t% s")
          (todo   . " %i %(my/org-agenda-title) ")
          (tags   . " %i %(my/org-agenda-title) ")
          (search . " %i %(my/org-agenda-title) "))
        org-agenda-tags-column 0
        org-agenda-block-separator ?─
        org-agenda-time-grid
        '((daily today require-timed)
          (800 1000 1200 1400 1600 1800 2000)
          " ┄┄┄┄┄ " "┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄")
        org-agenda-current-time-string
        "◀── now ─────────────────────────────────────────────────"
        org-agenda-custom-commands
        '(("d" "Dashboard"
           ((agenda "" ((org-agenda-span 'day)
                        (org-agenda-overriding-header "Today")))
            (todo "NEXT" ((org-agenda-overriding-header "Next")))
            (todo "TODO|WAIT" ((org-agenda-overriding-header "Other tasks")))))))

  (setq org-capture-templates
        '(("t" "Task" entry (file "~/Notes/inbox.org")
           "* TODO %?\n%U" :empty-lines 1)
          ("l" "Task with link" entry (file "~/Notes/inbox.org")
           "* TODO %?\n%U\n%a" :empty-lines 1))
        org-refile-targets '((org-agenda-files :maxlevel . 2))))

(use-package ox-latex
  :defer t
  :config
  (setcar (cdr (assoc "article" org-latex-classes))
          "\\documentclass[11pt,a4paper]{article}"))

(use-package calendar
  :defer t
  :config
  (setq calendar-week-start-day 1))

(use-package org-roam
  :defer t
  :commands (org-roam-buffer-toggle org-roam-tag-add org-roam-alias-add)
  :init
  (setq org-roam-directory (file-truename "~/Notes")
        org-roam-db-location
        (expand-file-name "emacs/org-roam.db"
                          (or (getenv "XDG_CACHE_HOME") "~/.cache")))

  :config
  (setq org-roam-completion-everywhere t
        org-roam-dailies-directory "daily/"
        org-roam-dailies-capture-templates
        '(("d" "default" entry "* %<%H:%M> %?"
           :target (file+head "%<%Y-%m-%d>.org" "#+title: %<%Y-%m-%d>\n"))))
  (org-roam-db-autosync-mode))

(use-package org-modern
  :hook ((org-mode . org-modern-mode)
         (org-agenda-finalize . org-modern-agenda))
  :config
  (setq org-modern-star 'replace))

(use-package org-appear
  :hook (org-mode . org-appear-mode))

(provide 'aperture-org)
