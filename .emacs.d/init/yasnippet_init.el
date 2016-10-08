;; yasnippet
(require 'yasnippet) ;; not yasnippet-bundle
(yas-global-mode 1)
(add-to-list 'yas/root-directory "~/.emacs.d/snippets")
(yas/initialize)

(add-hook 'elixir-mode-hook
          (lambda ()
            (setq yas-buffer-local-condition 't)))
