;;; -*- lexical-binding: t; -*-

;; buffer-local direnv environments; must be enabled late in init
(use-package envrc
  :config
  (setopt envrc-async t)

  (defvar-local my/envrc--pending-eglot nil
    "Deferred `eglot-ensure' call, waiting for envrc to apply the env.")

  (define-advice eglot-ensure (:around (orig) envrc-defer)
    "Hold eglot until envrc has sourced this buffer's environment."
    (if (or (not envrc-global-mode)
            (file-remote-p default-directory)
            (not (executable-find envrc-direnv-executable))
            (and envrc-mode (not envrc--running)))
        (funcall orig)
      (setq my/envrc--pending-eglot orig)))

  (define-advice envrc--apply (:after (buf result) eglot-release)
    "Run a deferred `eglot-ensure' once the environment has been applied."
    (unless (eq result 'running)
      (with-current-buffer buf
        (when-let* ((fn my/envrc--pending-eglot))
          (setq my/envrc--pending-eglot nil)
          (funcall fn)))))

  (envrc-global-mode))

(provide 'aperture-envrc)
