;;; -*- Emacs-Lisp -*-
;;; -*- coding: utf-8 -*-

;(require 'gtags)
(add-hook 'java-mode-hook (lambda () (gtags-mode 1)))
;(add-hook 'c-mode-common-hook (lambda () (gtags-mode 1)))
(add-hook 'rust-mode-hook (lambda () (gtags-mode 1)))

(add-hook 'gtags-mode-hook
          '(lambda ()
             (define-key gtags-mode-map (kbd "M-r") 'gtags-find-rtag)))
