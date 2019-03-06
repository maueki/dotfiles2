
(use-package company
  :bind
  (:map company-mode-map
        ("C-c TAB" . company-complete))
  (:map company-active-map
        ("C-n" . company-select-next)
        ("C-p" . company-select-previous)
        ("TAB" . company-complete-selection))
  (:map company-search-map
        ("C-n" . company-select-next)
        ("C-p" . company-select-previous))
  :config
  (global-company-mode)
  :custom
  (company-idle-delay 0)
  (company-minimum-prefix-length .5)
  (company-selection-wrap-around t)
  :diminish company-mode)

(use-package irony
  :config
  (use-package company-irony
    :config
    (push 'company-irony company-backends)))

(use-package flymake
  :custom
  (flymake-no-changes-timeout 2))

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
              ("C-c C-r" . eglot-code-actions)
              ("C-c C-w" . eglot-help-url-to-browser))
  :hook
  ((c-mode-common . eglot-ensure))
  :config
  (defun eglot-help-url-to-browser ()
    "Request information url for the thing at point to brower."
    (interactive)
    (eglot--dbind ((Hover) contents range)
        (jsonrpc-request (eglot--current-server-or-lose) :textDocument/hover
                         (eglot--TextDocumentPositionParams))
      (when (seq-empty-p contents) (eglot--error "No hover info here"))
      (let ((blurb (eglot--hover-info contents range)))
        (if (string-match "^\\(https://.*\\)$" blurb)
            (browse-url (match-string 1 blurb))
          (eglot--error "No url found"))))
    )
)

