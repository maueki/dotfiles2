
(add-to-list 'auto-mode-alist '("\\.cpp$" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.h$" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.c$" . c-mode))

(defun switch-default-c-mode ()
  (interactive)
  (progn
    (remove-hook 'c-mode-hook 'video-c-mode)
    (remove-hook 'c++-mode-hook 'video-c-mode)
    (add-hook 'c-mode-hook 'default-c-mode)
    (add-hook 'c++-mode-hook 'default-c-mode)
))

(defun switch-video-c-mode ()
  (interactive)
  (progn
    (remove-hook 'c-mode-hook 'default-c-mode)
    (remove-hook 'c++-mode-hook 'default-c-mode)
    (add-hook 'c-mode-hook 'video-c-mode)
    (add-hook 'c++-mode-hook 'video-c-mode)
))

(defun default-c-mode ()
  (c-set-style "stroustrup")
  (setq tab-width 4)
  (setq c-basic-offset 4)
  (setq indent-tabs-mode nil)     ; インデントは空白文字で行う（TABコードを空白に変換）
  (c-set-offset 'innamespace 0)   ; namespace {}の中はインデントしない
  (c-set-offset 'arglist-close 0) ; 関数の引数リストの閉じ括弧はインデントしない
)

(defun video-c-mode ()
  (c-set-style "stroustrup")
  (setq tab-width 4)
  (setq c-basic-offset 4)
  (setq indent-tabs-mode t)       ; インデントはTABで行う
  (c-set-offset 'innamespace 0)   ; namespace {}の中はインデントしない
  (c-set-offset 'arglist-close 0) ; 関数の引数リストの閉じ括弧はインデントしない
)

(switch-default-c-mode)
