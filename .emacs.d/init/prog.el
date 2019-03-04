
(use-package company
  :bind (:map company-mode-map
              ("C-c TAB" . company-complete))
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

(use-package projectile
  :config
  (defun projectile-project-find-function (dir)
    (let* ((root (projectile-project-root dir)))
      (and root (cons 'transient root))))
  (with-eval-after-load 'project
    (add-to-list 'project-find-functions 'projectile-project-find-function))
  )

(use-package eglot
  :bind (:map eglot-mode-map
              ("C-c C-d" . eglot-help-at-point)
              ("C-c C-r" . eglot-code-actions))
  :hook
  ((c-mode-common . eglot-ensure))
  )
