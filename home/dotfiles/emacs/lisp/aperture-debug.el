;;; -*- lexical-binding: t; -*-

;;;; Debugging

(use-package dape
  :commands (dape
             dape-breakpoint-toggle
             dape-next
             dape-evaluate-expression
             dape-watch-dwim
             dape-quit)
  :config
  (setopt dape-buffer-window-arrangement 'right
          dape-inlay-hints t)
  (add-to-list 'meow-mode-state-list '(dape-info-parent-mode . normal)))

;;;; Java

(defun aperture-jdtls-contact (&rest _)
  "Start jdtls with the java-debug jar from the project's devshell."
  `("jdtls" :initializationOptions
    (:bundles ,(vconcat
                (when-let* ((dir (getenv "JAVA_DEBUG_PLUGIN_DIR")))
                  (file-expand-wildcards
                   (expand-file-name "com.microsoft.java.debug.plugin-*.jar" dir)))))))

(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
               '((java-mode java-ts-mode) . aperture-jdtls-contact)))

(provide 'aperture-debug)
