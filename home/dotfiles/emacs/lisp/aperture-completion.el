;;; -*- lexical-binding: t; -*-

;;;; Completion

(use-package vertico
  :bind (:map vertico-map
              ("C-j" . vertico-next)
              ("C-k" . vertico-previous))
  :init
  (vertico-mode 1))

(use-package orderless
  :init
  (setq completion-styles '(orderless basic)))

(use-package consult)

(use-package corfu
  :bind (:map corfu-map
              ("C-j" . corfu-next)
              ("C-k" . corfu-previous))
  :init
  (setq corfu-auto t
        corfu-auto-prefix 3
        corfu-auto-delay 0.1
        corfu-cycle t)
  (global-corfu-mode 1)
  :config
  (corfu-popupinfo-mode 1))

(provide 'aperture-completion)
