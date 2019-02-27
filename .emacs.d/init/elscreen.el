;;; -*- Emacs-Lisp -*-
;;; -*- coding: utf-8 -*-

(use-package elscreen
  :init
  (define-key global-map (kbd "M-t") 'elscreen-clone)
  ; C-', C-;でscreenを移動
  ;(global-set-key [?\C-'] 'elscreen-next)
  ;(define-key global-map (kbd "M-'") 'elscreen-next)
  ;(global-set-key [?\C-;] 'elscreen-previous)
  ;(define-key global-map (kbd "M-;") 'elscreen-previous)
  ;(global-set-key [?\C-t] 'elscreen-clone)
  (elscreen-start)
)

