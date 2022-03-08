(set-fontset-font t 'japanese-jisx0208 (font-spec :family "Ricty Diminished"))
(set-fontset-font t 'ascii (font-spec :family "Ricty Diminished"))

(require 'mozc)
(setq default-input-method "japanese-mozc")

(use-package exec-path-from-shell
  :config
  (exec-path-from-shell-copy-envs '("PATH"))
)

(set-face-attribute 'default nil :height 120)

(setq frame-resize-pixelwise t)

(require 'ansi-color)
(defun colorize-compilation-buffer ()
  (toggle-read-only)
  (ansi-color-apply-on-region compilation-filter-start (point))
  (toggle-read-only))
(add-hook 'compilation-filter-hook 'colorize-compilation-buffer)

(defun turn-on-cargo-atcoder-hook ()
  (cond ((string-match "^/home/insight/AtCoder/" buffer-file-name)
         (cargo-atcoder-mode 1))))

(add-hook 'rust-mode-hook 'turn-on-cargo-atcoder-hook)

; term-modeでファイルをたどれる
(add-hook 'term-mode-hook 'compilation-minor-mode)
