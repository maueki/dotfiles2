; -*- coding: utf-8 -*-

(when load-file-name
  (setq user-emacs-directory (file-name-directory load-file-name)))

(load (concat user-emacs-directory "init-el-get.el"))

(init-loader-load (concat user-emacs-directory "init-loader"))
