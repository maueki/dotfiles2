;;; -*- Emacs-Lisp -*-
;;; -*- coding: utf-8 -*-

(require 'gtags)
(add-hook 'java-mode-hook (lambda () (gtags-mode 1)))
(add-hook 'c-mode-hook (lambda () (gtags-mode 1)))
(add-hook 'c++-mode-hook (lambda () (gtags-mode 1)))
(add-hook 'rust-mode-hook (lambda () (gtags-mode 1)))

(global-set-key (kbd "M-r") 'gtags-find-rtag)
