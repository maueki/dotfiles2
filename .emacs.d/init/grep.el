(require 'grep-a-lot)

; for grep-edit
;(require 'grep-edit)
(global-set-key [f2] 'rgrep)

;; http://d.hatena.ne.jp/kitokitoki/20110213/p1
;; grep-a-lotバッファ名改善
(defvar my-grep-a-lot-search-word nil)

;;上書き
(defun grep-a-lot-buffer-name (position)
  "Return name of grep-a-lot buffer at POSITION."
  (concat "*grep*<" my-grep-a-lot-search-word ">"))

(defadvice rgrep (before my-rgrep (regexp &optional files dir confirm) activate)
  (setq my-grep-a-lot-search-word regexp))

(defadvice lgrep (before my-lgrep (regexp &optional files dir confirm) activate)
  (setq my-grep-a-lot-search-word regexp))
