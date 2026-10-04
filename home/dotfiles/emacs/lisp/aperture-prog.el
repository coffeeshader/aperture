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
          typst-ts-mode
          ) . eglot-ensure)
  :config
  (setq eglot-autoshutdown t
        eglot-events-buffer-config '(:size 0 :format short)
        eglot-ignored-server-capabilities '(:documentOnTypeFormattingProvider)
        eglot-code-action-indicator "")
  (add-to-list 'eglot-server-programs
               '(typst-ts-mode "tinymist"
                 :initializationOptions (:formatterMode "typstyle"))))

(use-package eldoc-box
  :commands eldoc-box-help-at-point)

(use-package compile
  :defer t
  :config
  (setopt compilation-ask-about-save nil
          compilation-scroll-output t
          compilation-max-output-line-length nil
          compile-command ""))

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

(use-package typst-ts-mode
  :mode "\\.typ\\'"
  :hook (typst-ts-mode . aperture-typst-watch-command))

(defun aperture-typst-watch-command ()
  "Make `compile' run typst watch on the current file."
  (when buffer-file-name
    (setq-local compile-command
                (concat "typst watch "
                        (shell-quote-argument
                         (file-name-nondirectory buffer-file-name))))))

(add-to-list 'major-mode-remap-alist '(c-mode . c-ts-mode))
(add-to-list 'major-mode-remap-alist '(c++-mode . c++-ts-mode))
(add-to-list 'major-mode-remap-alist '(java-mode . java-ts-mode))
(add-to-list 'major-mode-remap-alist '(rust-mode . rust-ts-mode))

(setq-default c-ts-mode-indent-style 'bsd
              c-ts-indent-offset 4)

;;;; Code screenshots

(defvar aperture-freeze-directory "~/Pictures/freeze/"
  "Directory `aperture-freeze-region' writes its SVGs to.")

(defun aperture-freeze--language ()
  (if-let* ((file buffer-file-name)
            (ext (file-name-extension file)))
      ext
    (replace-regexp-in-string "\\(-ts\\)?-mode\\'" "" (symbol-name major-mode))))

(defun aperture-freeze--dedent (text)
  (let* ((lines (split-string text "\n"))
         (indent (seq-min
                  (or (mapcan (lambda (line)
                                (unless (string-match-p "\\`[ \t]*\\'" line)
                                  (list (- (length line)
                                           (length (string-trim-left line))))))
                              lines)
                      '(0)))))
    (mapconcat (lambda (line) (substring line (min indent (length line))))
               lines "\n")))

(defun aperture-freeze-region (beg end &optional file)
  "Render the region, or the whole buffer, to an SVG with charm freeze.
The file lands in `aperture-freeze-directory' and its path is copied.
With a prefix argument, prompt for FILE instead."
  (interactive
   (append (if (use-region-p)
               (list (region-beginning) (region-end))
             (list (point-min) (point-max)))
           (when current-prefix-arg
             (list (read-file-name "Save SVG to: " aperture-freeze-directory)))))
  (let* ((text (aperture-freeze--dedent
                (string-trim-right (buffer-substring-no-properties beg end) "\n+")))
         (first (line-number-at-pos beg))
         (last (+ first (1- (length (split-string text "\n")))))
         (file (expand-file-name
                (or file (format "%s-%d-%d.svg"
                                 (file-name-base (or buffer-file-name (buffer-name)))
                                 first last))
                aperture-freeze-directory))
         (lang (aperture-freeze--language)))
    (make-directory (file-name-directory file) t)
    (with-temp-buffer
      (unless (zerop (call-process-region text nil "freeze" nil t nil
                                          "--language" lang "--output" file))
        (error "freeze: %s" (string-trim (buffer-string)))))
    (deactivate-mark)
    (kill-new file)
    (message "Froze %d lines to %s" (1+ (- last first)) file)))

(provide 'aperture-prog)
