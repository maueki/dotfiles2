(autoload 'markdown-mode "markdown-mode"
  "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

(require 'guess-offset)

(require 'elixir-mode)
(require 'qml-mode)

(require 'elixir-mix)
(global-elixir-mix-mode)

(require 'adoc-mode)
