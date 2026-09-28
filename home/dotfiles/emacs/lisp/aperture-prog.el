;;; -*- lexical-binding: t; -*-

;;;; Language Modes / LSP / Code editing stuff

(use-package eglot
  :hook ((rust-ts-mode
          java-ts-mode
          zig-mode
          python-mode
          c-ts-mode
          c++-ts-mode
          nix-mode
          ) . eglot-ensure)
  :config
  (setq eglot-autoshutdown t
        eglot-events-buffer-config '(:size 0 :format short)
        eglot-ignored-server-capabilities '(:documentFormattingProvider
                                            :documentOnTypeFormattingProvider
                                            :documentRangeFormattingProvider)
        eglot-code-action-indicator ""))

(use-package eldoc-box
  :commands eldoc-box-help-at-point)

(use-package compile
  :defer t
  :config
  (setopt compilation-ask-about-save nil
          compilation-scroll-output t
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
                                             (note "!" compilation-info)))
  (put 'eglot-flymake-backend 'flymake-always-safe t))

(use-package rust-mode
  :init
  (setq rust-mode-treesitter-derive t))

(use-package zig-mode)

(use-package nix-mode
  :mode "\\.nix\\'")

(add-to-list 'major-mode-remap-alist '(c-mode . c-ts-mode))
(add-to-list 'major-mode-remap-alist '(c++-mode . c++-ts-mode))
(add-to-list 'major-mode-remap-alist '(java-mode . java-ts-mode))
(add-to-list 'major-mode-remap-alist '(rust-mode . rust-ts-mode))

(setq-default c-ts-mode-indent-style 'bsd
              c-ts-indent-offset 4)

(provide 'aperture-prog)
