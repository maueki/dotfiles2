(autoload 'markdown-mode "markdown-mode"
  "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

(require 'elixir-mode)
(require 'qml-mode)

(require 'adoc-mode)

(setq tramp-copy-size-limit nil)
(setq tramp-inline-compress-start-size nil)
(setq password-cache-expiry nil)

(add-to-list 'auto-mode-alist '("\\.pu$" . puml-mode))
(require 'puml-mode)

; basic_setting.el にも書いてあるけどここじゃないと有効にならない...
(savehist-mode 1)
