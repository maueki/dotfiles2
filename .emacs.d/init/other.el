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
;(setq vc-handled-backends ())

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

(use-package doom-themes
  :if window-system
  :custom
  (doom-themes-enable-italic t)
  (doom-themes-enable-bold t)
  :custom-face
;  (doom-modeline-bar ((t (:background "#6272a4"))))
  :config
  (load-theme 'doom-one t)
;  (doom-themes-neotree-config)
  (doom-themes-org-config)
  )

(use-package doom-modeline
  :if window-system
  :custom
  (doom-modeline-buffer-file-name-style 'truncate-with-project)
  (doom-modeline-icon t)
  :hook
  (after-init . doom-modeline-mode)
  :config
;  (doom-modeline-def-modeline 'main
;    '(bar workspace-number window-number evil-state god-state ryo-modal xah-fly-keys matches buffer-info remote-host buffer-position parrot selection-info)
;    '(misc-info persp-name lsp github debug minor-modes input-method major-mode process vcs checker))
  )

(use-package which-key
  :diminish which-key-mode
  :hook (after-init . which-key-mode))

(use-package amx)

(use-package all-the-icons)

(use-package git-gutter
  :custom
  (git-gutter:modified-sign "~")
  (git-gutter:added-sign    "+")
  (git-gutter:deleted-sign  "-")
  :custom-face
  (git-gutter:modified ((t (:background "#f1fa8c"))))
  (git-gutter:added    ((t (:background "#50fa7b"))))
  (git-gutter:deleted  ((t (:background "#ff79c6"))))
  :config
  (global-git-gutter-mode +1))

(use-package ace-window
  :bind
  (("C-c C-j" . ace-window))
  :custom-face
  (aw-leading-char-face ((t (:height 3.0 :foreground "#f1fa8c"))))
  )

;; transparency
(defun toggle-transparency ()
  (interactive)
  (let ((alpha (frame-parameter nil 'alpha)))
    (set-frame-parameter
     nil 'alpha
     (if (eql (cond ((numberp alpha) alpha)
                    ((numberp (cdr alpha)) (cdr alpha))
                    ;; Also handle undocumented (<active> <inactive>) form.
                    ((numberp (cadr alpha)) (cadr alpha)))
              100)
         '(90 . 90) '(100 . 100)))))
(global-set-key (kbd "C-c t") 'toggle-transparency)
