(setq custom-file "~/.emacs.d/site-lisp/custom.el")
(if (file-exists-p (expand-file-name "~/.emacs.d/site-lisp/custom.el"))
    (load (expand-file-name custom-file) t nil nil))

; for emacs24.4
(if (fboundp 'package--ac-desc-version)
    (fset 'package-desc-vers 'package--ac-desc-version))

(setq load-path
      (append
       load-path
       (list
        (expand-file-name "~/.emacs.d/site-lisp/")
        (expand-file-name "~/.emacs.d/site-lisp/magit/lisp")
        (expand-file-name "~/.emacs.d/local/")
        "/usr/local/share/emacs/site-lisp/rtags"
       )))

; open cheat sheet
(global-set-key [f12] '(lambda () (interactive) (browse-url "http://qiita.com/maueki/private/32b604b58578a354b287")))

;; anything
;(require 'anything-startup)

;(global-set-key (kbd "M-y") 'anything-show-kill-ring)
;(global-set-key (kbd "C-x b") 'anything-for-files)

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

(require 'migemo)
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

(setq-default indent-tabs-mode nil)

; 改行時のindentを抑制
(electric-indent-mode -1)

;; East Asian Ambiguous Width -> full width
;(require 'eaw)
;(eaw-fullwidth)

;; clang format
(load "~/.emacs.d/site-lisp/clang-format.el")
(global-set-key (kbd "C-M-c") 'clang-format-buffer)

(require 'grep-a-lot)

(global-anzu-mode +1)

(require 'auto-highlight-symbol)
(global-auto-highlight-symbol-mode t)
