;;; -*- lexical-binding: t; -*-

(setopt native-comp-async-report-warnings-errors 'silent)

(add-to-list 'load-path (locate-user-emacs-file "lisp"))

(require 'aperture-ui)
(require 'aperture-completion)
(require 'aperture-prog)
(require 'aperture-org)
(require 'aperture-git)
(require 'aperture-meow)
(require 'aperture-defaults)

(load-file custom-file)

(require 'aperture-envrc)

(provide 'init)
