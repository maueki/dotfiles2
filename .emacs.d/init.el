;;; -*- Emacs-Lisp -*-
;;; -*- coding: utf-8 -*-

(setq custom-file "~/.emacs.d/site-lisp/custom.el")
(if (file-exists-p (expand-file-name "~/.emacs.d/site-lisp/custom.el"))
    (load (expand-file-name custom-file) t nil nil))

(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(package-initialize)

;; for emacs24.4
(if (fboundp 'package--ac-desc-version)
    (fset 'package-desc-vers 'package--ac-desc-version))

(require 'melpa)

(setq load-path
      (append
       (list
       (expand-file-name "~/.emacs.d/site-lisp/")
       (expand-file-name "~/.emacs.d/local/")
       )
       load-path))

; open cheat sheet
(global-set-key [f12] '(lambda () (interactive) (browse-url "http://qiita.com/maueki/private/32b604b58578a354b287")))

;; anything
;(require 'anything-startup)

;(global-set-key (kbd "M-y") 'anything-show-kill-ring)
;(global-set-key (kbd "C-x b") 'anything-for-files)

;; helm
(require 'helm-config)
(require 'helm-ls-git)

(global-set-key (kbd "M-y") 'helm-show-kill-ring)
(global-set-key (kbd "C-x b") 'helm-for-files)
(global-set-key (kbd "C-x I") 'helm-imenu)
(global-set-key (kbd "C-x r l") 'helm-bookmarks)

(setq helm-for-files-preferred-list
      '(helm-source-buffers-list
	helm-source-ls-git
        helm-source-recentf
        helm-source-file-cache
        ;; helm-source-files-in-current-dir
        helm-source-locate))

(global-font-lock-mode t)
;(load "term/bobcat")

;; skk
;(set-input-method "japanese-skk")
;(inactivate-input-method)

;; 対応するカッコをハイライト
(show-paren-mode)

;moccur
;(require 'color-moccur)
;(require 'moccur-edit)

;(load "term/keyswap")

(keyboard-translate ?\C-h ?\C-?)

;(require 'migemo)
;(load "migemo")

;C-xjでSKKが起動しないようにする
;(global-set-key "\C-xj" 'register-to-point)

;; 以下独自設定

;行番号を表示させる
;(require 'linum)
;(setq linum-format "%5d|")
;(global-linum-mode)

;Meta-gで行移動できるようにする
(global-set-key "\M-g" 'goto-line)

(set-language-environment "Japanese")
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-buffer-file-coding-system 'utf-8)
(setq default-buffer-file-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

;; C-x bで存在しないバッファを指定して新規バッファを開いたときにはデフォルトでlisp-interaction-modeが起動する。
(setq default-major-mode 'lisp-interaction-mode)

; 末尾の改行を自動で付けない
(setq require-final-newline nil)
(setq next-line-add-newlines nil)

;; shift-tabでwindowを移動する
(global-set-key [backtab] 'other-window)

;; 現在の行をハイライト
;(global-hl-line-mode t)

;; ediff関連のバッファを１つのフレームにまとめる
(setq ediff-window-setup-function 'ediff-setup-windows-plain)

; for grep-edit
;(require 'grep-edit)
(global-set-key [f2] 'rgrep)

;; egg
(require 'egg)

;; redo+.el
(require 'redo+)
(global-set-key (kbd "C-M-_") 'redo)
(setq undo-no-redo t) ; 過去のundoがredoされないようにする
(setq undo-limit 600000)
(setq undo-strong-limit 900000)

;; recentf
;; 最近のファイルの10000個を保存する
(setq recentf-max-saved-itemds 10000)
(setq recentf-exclude '("/TAGS$" "/var/tmp/"))
(require 'recentf-ext)

;;; 履歴を次回のEmacs起動時にも保存する
(savehist-mode 1)

;;; ファイル内のカーソルを記憶する
(setq-default save-place t)
(require 'saveplace)

;;; モードラインに時刻を表示
(display-time)

;;; GCを減らして軽くする
(setq gc-cons-threshold (* 10 gc-cons-threshold))

;;; ログの記録行数を増やす
(setq message-log-max 10000)

;;; ミニバッファを再帰的に呼び出せるようにする
(setq enable-recursive-minibuffers t)

;;; ダイアログボックスを使わないようにする
;(setq use-dialog-box nil)
;(defalias 'message-box 'message)

;;;　履歴をたくさん保存する
(setq history-length 1000)

;;; キーストロークをエコーエリアに早く表示する
;(setq echo-keystrokes 0.1)

;;; ツールバーを消す
(tool-bar-mode -1)

;; ipa
(require 'ipa)

;;; GDB 関連
;;; 有用なバッファを開くモード
(setq gdb-many-windows t)

;;; 変数の上にマウスカーソルを置くと値を表示
(add-hook 'gdb-mode-hook '(lambda () (gud-tooltip-mode t)))

;;; I/O バッファを表示
(setq gdb-use-separate-io-buffer t)

;;; t にすると mini buffer に値が表示される
(setq gud-tooltip-echo-area nil)

;;; shell-mode
(defun setup-sh-mode ()
  "My own personal preferences for `sh-mode'.

This is a custom function that sets up the parameters I usually
prefer for `sh-mode'.  It is automatically added to
`sh-mode-hook', but is can also be called interactively."
  (interactive)
  (setq sh-basic-offset 2
        sh-indentation 2))
(add-hook 'sh-mode-hook 'setup-sh-mode)

(require 'grep-a-lot)
;(grep-a-lot-setup-keys)

(require 'anzu)
(global-anzu-mode +1)

(autoload 'markdown-mode "markdown-mode"
  "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

(require 'auto-complete)
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/ac-dict")
(ac-config-default)
(require 'auto-complete-clang-async)

(require 'auto-highlight-symbol)
(global-auto-highlight-symbol-mode t)

(add-to-list 'auto-mode-alist '("\\.mm\\'" . objc-mode))

(when (boundp 'show-trailing-whitespace)
  (setq-default show-trailing-whitespace t))
(set-face-background 'trailing-whitespace "purple4")

(setq whitespace-style
      '(face tabs tab-mark spaces space-mark))

(setq whitespace-space-regexp "\\(\x3000+\\)")
(setq whitespace-display-mappings
      '((space-mark ?\x3000 [?\□])
        (tab-mark   ?\t   [?\xBB ?\t])
        ))

(require 'whitespace)
(set-face-foreground 'whitespace-space "aaaaaa")
(set-face-background 'whitespace-space 'nil)
(set-face-foreground 'whitespace-tab "#444444")
(set-face-background 'whitespace-tab 'nil)
(global-whitespace-mode 1)

(require 'init-loader)
;(init-loader-load "~/.emacs.d/inits")
(let ((init-local "~/inits-local"))
  (if (file-exists-p init-local)
      (init-loader-load init-local)))

(require 'go-autocomplete)
(add-hook 'before-save-hook 'gofmt-before-save)

(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))

(setq-default indent-tabs-mode nil)

(define-key web-mode-map (kbd "M-;") nil)

(defun web-mode-hook ()
  "Hooks for Web mode."
  (setq web-mode-markup-indent-offset   2)
  (setq web-mode-code-indent-offset 2))

(add-hook 'web-mode-hook 'web-mode-hook)
(add-hook 'web-mode-hook  'emmet-mode) ;; enable Emmet's css abbreviation.
(add-hook 'emmet-mode-hook (lambda () (setq emmet-indentation 2))) ;; indent 2 spaces.

(require 'guess-offset)

(add-hook
 'go-mode-hook
 '(lambda ()
    ;; Imenu & Speedbar
    (setq imenu-generic-expression
          '(("type" "^type *\\([^ \t\n\r\f]*\\)" 1)
            ("func" "^func *\\(.*\\) {" 1)))
    (imenu-add-to-menubar "Index")))

