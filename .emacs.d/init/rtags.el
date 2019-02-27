
(use-package rtags
  :config
  (setq rtags-autostart-diagnostics t)
  (rtags-diagnostics)
  (setq rtags-completions-enabled t)
  (push 'company-rtags company-backends)

  (add-hook
   'c-mode-common-hook
   (rtags-start-process-unless-running))

  (add-hook
   'c++-mode-common-hook
   (rtags-start-process-unless-running))

  (rtags-enable-standard-keybindings c-mode-base-map "\C-cr")

  (use-package company-rtags
    :init
    (push 'company-rtags company-backends)
    )
  (use-package helm-rtags
    :init
    (setq rtags-use-helm t)
    :config
    (setq rtags-display-result-backend 'helm)
    )
  )
