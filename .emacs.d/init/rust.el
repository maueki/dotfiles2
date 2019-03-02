
(use-package eglot
  :bind (:map eglot-mode-map
              ("C-c C-d" . eglot-help-at-point)
              ("C-c C-r" . eglot-code-actions))
  )

(use-package rustic
  :config
  (setq rustic-rls-pkg 'eglot)
  )

