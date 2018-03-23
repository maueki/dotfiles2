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

; google-translate for c/c++ comment
(require 'google-translate)
(require 'google-translate-smooth-ui)
(global-set-key (kbd "C-c t") 'google-translate-smooth-translate)
(setq google-translate-translation-directions-alist '(("en" . "ja") ("ja" . "en")))

(defun remove-c-comment (args)
  (let ((text (nth 2 args)))
    (setf (nth 2 args) (replace-regexp-in-string "[ \t]+//[ \t]+" ""
                                                 (replace-regexp-in-string "[ \t]+\\(\\*[ \t]+\\)+" " " text)))
    args))

(advice-add 'google-translate-request :filter-args
            #'remove-c-comment)

; editorconfig
(require 'editorconfig)
(editorconfig-mode 1)
(defun x-clipboard-copy ()
  (interactive)
  (when (region-active-p)
    (shell-command-on-region (region-beginning) (region-end) "xsel -ib" nil nil)))
