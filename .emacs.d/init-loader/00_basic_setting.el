; for emacs24.4
(if (fboundp 'package--ac-desc-version)
    (fset 'package-desc-vers 'package--ac-desc-version))

(setq load-path
      (append
       load-path
       (list
        (expand-file-name "~/.emacs.d/site-lisp/")
        (expand-file-name "~/.emacs.d/local/")
        "/usr/local/share/emacs/site-lisp/rtags"
       )))

; http://qiita.com/8bit-jzjjy/items/7af68074494b5e9129e5
; 外部プロセス文字化け防止
(defmacro my-adapt-coding-system-with-current-buffer (target-function)
  `(defadvice ,target-function
     (around my-adapt-coding-system-with-current-buffer activate)
     (let ((coding-system-for-read buffer-file-coding-system)
       (coding-system-for-write buffer-file-coding-system)
       (coding-system-require-warning t))
       ad-do-it)))

; open cheat sheet
(global-set-key [f12] '(lambda () (interactive) (browse-url "http://qiita.com/maueki/private/32b604b58578a354b287")))

(global-set-key [f1] 'help-command)

(global-set-key [f3] 'helm-grep-do-git-grep)

(global-font-lock-mode t)

;; 対応するカッコをハイライト
(show-paren-mode)

;(load "term/bobcat")
(keyboard-translate ?\C-h ?\C-?)

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

;; redo+.el
;(use-package redo+
;  :bind (("C-M-_" . redo))
;  :config
;  (setq undo-no-redo t) ; 過去のundoがredoされないようにする
;  (setq undo-limit 600000)
;  (setq undo-strong-limit 900000)
;)

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
;(display-time)

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

;;; メニューバーを消す
(menu-bar-mode -1)

;;; スクロールバーを消す
(scroll-bar-mode -1)

;;; GDB 関連
;;; 有用なバッファを開くモード
(setq gdb-many-windows t)

;;; 変数の上にマウスカーソルを置くと値を表示
(add-hook 'gdb-mode-hook '(lambda () (gud-tooltip-mode t)))

;;; I/O バッファを表示
(setq gdb-use-separate-io-buffer t)

;;; t にすると mini buffer に値が表示される
(setq gud-tooltip-echo-area nil)

(setq-default indent-tabs-mode nil)

; 改行時のindentを抑制
(electric-indent-mode -1)

;; clang format
(load "~/.emacs.d/site-lisp/clang-format.el")
(global-set-key (kbd "C-M-c") 'clang-format-buffer)

(custom-set-variables
 '(vc-follow-symlinks t) ;; symlink 開くのに警告を出さない
 )

(global-set-key (kbd "C-'") 'other-window)

;; hs-minor-mode
(add-hook 'c-mode-common-hook   'hs-minor-mode)
(add-hook 'emacs-lisp-mode-hook 'hs-minor-mode)
(add-hook 'java-mode-hook       'hs-minor-mode)
(add-hook 'lisp-mode-hook       'hs-minor-mode)
(add-hook 'perl-mode-hook       'hs-minor-mode)
(add-hook 'sh-mode-hook         'hs-minor-mode)
