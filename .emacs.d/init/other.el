(use-package markdown-mode
  :mode (("\\.text\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode)
         ("\\.md\\'" . markdown-mode))
)

(use-package tramp
  :config
  (setq tramp-copy-size-limit nil)
  (setq tramp-inline-compress-start-size nil)
  (setq password-cache-expiry nil)
)

;;----------------------------------------
;; vc-mode は使わない
;;  http://stackoverflow.com/questions/5748814/how-does-one-disable-vc-git-in-emacs
;;----------------------------------------
(setq vc-handled-backends ())

(use-package plantuml-mode
  :mode (("\\.pu$" . plantuml-mode))
)

(use-package google-translate
  :bind
  (("C-c t" . google-translate-enja-or-jaen))
  :config
;  (setq google-translate-translation-directions-alist '(("en" . "ja") ("ja" . "en")))

  (defun google-translate-enja-or-jaen (&optional string)
    "Translate words in region or current position. Can also specify query with C-u"
    (interactive)
    (setq string
          (cond ((stringp string) string)
                (current-prefix-arg
                 (read-string "Google Translate: "))
                ((use-region-p)
                 (buffer-substring (region-beginning) (region-end)))
                (t
                 (thing-at-point 'word))))
    (let* ((asciip (string-match
                    (format "\\`[%s]+\\'" "[:ascii:]’“”–")
                    string)))
      (run-at-time 0.1 nil 'deactivate-mark)
      (google-translate-translate
       (if asciip "en" "ja")
       (if asciip "ja" "en")
       string)))

  (defun remove-c-comment (args)
    (let ((text (nth 2 args)))
      (setf (nth 2 args) (replace-regexp-in-string "[ \t]+//[ \t]+" ""
                                                   (replace-regexp-in-string "[ \t]+\\(\\*[ \t]+\\)+" " " text)))
      args))

  (advice-add 'google-translate-request :filter-args
              #'remove-c-comment)
)

(use-package editorconfig
  :init
  (editorconfig-mode 1)
)
