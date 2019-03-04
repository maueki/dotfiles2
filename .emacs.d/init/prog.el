
(use-package company
  :config
  (global-company-mode)

  :diminish company-mode)

(use-package irony
  :config
  (use-package company-irony
    :config
    (push 'company-irony company-backends)))

(use-package flymake
  :config
  (setq flymake-no-changes-timeout 2))

(use-package eglot
  :bind (:map eglot-mode-map
              ("C-c C-d" . eglot-help-at-point)
              ("C-c C-r" . eglot-code-actions))
  :hook
  ((c-mode-common . eglot-ensure))
  )
