;;; -*- lexical-binding: t; -*-

;;;; Git

(use-package auth-source
  :config
  (setq auth-sources '("secrets:Companion Cube")))

(use-package forge
  :after magit
  :config
  (add-to-list 'forge-alist
               '("github-uni" "api.github.com" "github.com" forge-github-repository)))

(use-package diff-hl
  :demand t
  :custom
  (diff-hl-bmp-max-width 8)
  :hook ((magit-pre-refresh  . diff-hl-magit-pre-refresh)
         (magit-post-refresh . diff-hl-magit-post-refresh))
  :config
  (global-diff-hl-mode)
  (diff-hl-flydiff-mode))

(provide 'aperture-git)
