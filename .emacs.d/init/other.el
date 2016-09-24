(autoload 'markdown-mode "markdown-mode"
  "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

(require 'elixir-mode)
(require 'alchemist)

(require 'qml-mode)
(add-to-list 'auto-mode-alist '("\\.qml$" . qml-mode))

(require 'adoc-mode)

(setq tramp-copy-size-limit nil)
(setq tramp-inline-compress-start-size nil)
(setq password-cache-expiry nil)

(when (require 'puml-mode nil 'noerror)
  (add-to-list 'auto-mode-alist '("\\.pu$" . puml-mode)))
