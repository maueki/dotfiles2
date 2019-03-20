(add-to-list 'auto-mode-alist '("\\.cpp$" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.h$" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.c$" . c-mode))

(setq my-c-hook-list '(video-c-mode default-c-mode weston-c-mode))

(defun remove-all-c-hooks ()
  (dolist (hook my-c-hook-list)
    (progn
      (remove-hook 'c-mode-hook hook)
      (remove-hook 'c++-mode-hook hook))))

(defmacro create-switch-func (hookfunc)
  `(defun ,(intern (concat "switch-" (symbol-name hookfunc))) ()
     (interactive)
     (remove-all-c-hooks)
     (add-hook 'c-mode-hook ',hookfunc)
     (add-hook 'c++-mode-hook ',hookfunc)))

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

(defun weston-c-mode ()
  (c-set-style "stroustrup")
  (setq tab-width 8)
  (setq c-basic-offset 8)
  (setq indent-tabs-mode t)       ; インデントはTABで行う
  (c-set-offset 'innamespace 0)   ; namespace {}の中はインデントしない
  (c-set-offset 'arglist-close 0) ; 関数の引数リストの閉じ括弧はインデントしない
)

(create-switch-func default-c-mode)
(create-switch-func video-c-mode)
(create-switch-func weston-c-mode)

(switch-default-c-mode)
