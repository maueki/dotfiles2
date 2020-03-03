(use-package helm
  :bind
  (("M-y" . helm-show-kill-ring)
   ("C-x b" . helm-for-files)
   ("C-x I" . helm-semantic-or-imenu)
   ("C-x r l" . helm-bookmarks)
   ("M-x" . helm-M-x)
   ; "C-x C-f" . helm-find-files)
   ("C-<f6>" . helm-ls-git-ls)
   ("C-x C-d" . helm-browse-project))
  :config
  (use-package helm-ls-git)
  (custom-set-variables
   '(helm-source-ls-git (helm-ls-git-build-ls-git-source))
   '(helm-source-ls-git-status (helm-ls-git-build-git-status-source))
   '(helm-for-files-preferred-list
     '(helm-source-buffers-list
       helm-source-recentf
       helm-source-files-in-current-dir
       helm-source-ls-git-status
       helm-source-ls-git
       helm-source-file-cache
       helm-source-locate
       )))
  (use-package helm-xref
    :config
    (setq xref-show-xrefs-function 'helm-xref-show-xrefs))
)

;(when (require 'migemo nil 'noerror)
;  (helm-migemo-mode +1))

(use-package helm-git-grep
  :after (helm)
  :bind (("<f4>" . helm-git-grep-at-point))
  (:map helm-map ("<f4>" . helm-git-grep-from-helm))
)

(use-package magit
  :bind
  (("C-x g" . magit-status))
  )

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
  (flymake-no-changes-timeout 2)
  )

(use-package projectile
  :config
  (defun projectile-project-find-function (dir)
    (let* ((root (projectile-project-root dir)))
      (and root (cons 'transient root))))
  (with-eval-after-load 'project
    (add-to-list 'project-find-functions 'projectile-project-find-function))
  )

(use-package lsp-mode
  :custom
  ;; debug
  (lsp-print-io nil)
  (lsp-trace nil)
  (lsp-print-performance nil)
  ;; general
  (lsp-auto-guess-root t)
  (lsp-document-sync-method 'incremental) ;; always send incremental document
  (lsp-response-timeout 5)
  (lsp-prefer-flymake 'flymake)
  (lsp-enable-completion-at-point nil)
  (lsp-enable-on-type-formatting nil)
;  :hook
;  (go-mode . lsp)
  :bind
  (:map lsp-mode-map
        ("C-c r"   . lsp-rename))
  :config
  (require 'lsp-clients)
  ;; LSP UI tools
  (use-package lsp-ui
    :custom
    ;; lsp-ui-doc
    (lsp-ui-doc-enable t)
    (lsp-ui-doc-header t)
    (lsp-ui-doc-include-signature t)
    (lsp-ui-doc-position 'top) ;; top, bottom, or at-point
    (lsp-ui-doc-max-width 150)
    (lsp-ui-doc-max-height 30)
    (lsp-ui-doc-use-childframe t)
    (lsp-ui-doc-use-webkit nil)
    ;; lsp-ui-flycheck
    (lsp-ui-flycheck-enable nil)
    ;; lsp-ui-sideline
    (lsp-ui-sideline-enable nil)
    (lsp-ui-sideline-ignore-duplicate t)
    (lsp-ui-sideline-show-symbol t)
    (lsp-ui-sideline-show-hover t)
    (lsp-ui-sideline-show-diagnostics t)
    (lsp-ui-sideline-show-code-actions t)
    ;; lsp-ui-imenu
    (lsp-ui-imenu-enable nil)
    (lsp-ui-imenu-kind-position 'top)
    ;; lsp-ui-peek
    (lsp-ui-peek-enable t)
    (lsp-ui-peek-peek-height 20)
    (lsp-ui-peek-list-width 50)
    (lsp-ui-peek-fontify 'on-demand) ;; never, on-demand, or always
    :preface
    (defun ladicle/toggle-lsp-ui-doc ()
      (interactive)
      (if lsp-ui-doc-mode
        (progn
          (lsp-ui-doc-mode -1)
          (lsp-ui-doc--hide-frame))
         (lsp-ui-doc-mode 1)))
    :bind
    (:map lsp-mode-map
    ([remap xref-find-references] . lsp-ui-peek-find-references)
    ([remap xref-find-definitions] . lsp-ui-peek-find-definitions)
    ("C-c i"   . lsp-ui-peek-find-implementation)
    ("C-c m"   . lsp-ui-imenu)
    ("C-c s"   . lsp-ui-sideline-mode)
    ("C-c d"   . ladicle/toggle-lsp-ui-doc))
    :hook
    (lsp-mode . lsp-ui-mode))
  ;; Lsp completion
  (use-package company-lsp
    :custom
    (company-lsp-cache-candidates t) ;; always using cache
    (company-lsp-async t)
    (company-lsp-enable-recompletion nil)))

;; cclsは別途hookする
(use-package ccls
  :custom (ccls-executable "/usr/local/bin/ccls")
  :hook ((c-mode c++-mode objc-mode) .
         (lambda () (require 'ccls) (lsp))))

(use-package omnisharp
  :hook ((csharp-mode . omnisharp-mode)
         (csharp-mode . company-mode))
  :bind
  (:map omnisharp-mode-map
        ([remap xref-find-definitions] . omnisharp-go-to-definition)
        ([remap xref-find-references] . omnisharp-helm-find-usages)
        )
  :custom
  (eval-after-load
      'company
    '(add-to-list 'company-backends #'company-omnisharp))
  )

(use-package elpy
  :init
  (elpy-enable)
  :config
  (setq elpy-rpc-python-command "python3")
  )

(use-package py-autopep8
  :hook
  (python-mode . py-autopep8-enable-on-save)
)


(use-package pipenv
  :config
  ; https://github.com/jorgenschaefer/elpy/issues/1217
  (pyvenv-tracking-mode)
  (defun pipenv-auto-activate ()
    "Set `pyvenv-activate' to the current pipenv virtualenv.

This function is intended to be used in parallel with
 `pyvenv-tracking-mode'."
    (pipenv-deactivate)
    (pipenv--force-wait (pipenv-venv))
    (when python-shell-virtualenv-root
      (setq-local pyvenv-activate
                  (directory-file-name python-shell-virtualenv-root))
      (setq python-shell-virtualenv-root nil)))
  (add-hook 'elpy-mode-hook 'pipenv-auto-activate)
)

(use-package yasnippet
  :config
  (setq yas-snippet-dirs (list (expand-file-name "~/.emacs.d/snippets")))
  (yas-reload-all)
  (yas-global-mode 1)
)

(use-package yasnippet-snippets)

(use-package whitespace
  :config
  (when (boundp 'show-trailing-whitespace)
    (setq-default show-trailing-whitespace t))
  (set-face-background 'trailing-whitespace "purple4")

  (setq whitespace-style
        '(face tabs tab-mark spaces space-mark))

  (setq whitespace-space-regexp "\\(\x3000+\\)")
  (setq whitespace-display-mappings
        '((space-mark ?\x3000 [?\□])
          (tab-mark   ?\t   [?\xBB ?\t])
          ))

  (set-face-foreground 'whitespace-space "aaaaaa")
  (set-face-background 'whitespace-space 'nil)
  (set-face-foreground 'whitespace-tab "#444444")
  (set-face-background 'whitespace-tab 'nil)
                                        ;(global-whitespace-mode 1)

  (add-hook 'c-mode-common-hook 'whitespace-mode)
)

(use-package grep-a-lot
  :bind
  (([f2] . rgrep))

  :config
  ;; http://d.hatena.ne.jp/kitokitoki/20110213/p1
  ;; grep-a-lotバッファ名改善
  (defvar my-grep-a-lot-search-word nil)

  ;;上書き
  (defun grep-a-lot-buffer-name (position)
    "Return name of grep-a-lot buffer at POSITION."
    (concat "*grep*<" my-grep-a-lot-search-word ">"))

  (defadvice rgrep (before my-rgrep (regexp &optional files dir confirm) activate)
    (setq my-grep-a-lot-search-word regexp))

  (defadvice lgrep (before my-lgrep (regexp &optional files dir confirm) activate)
    (setq my-grep-a-lot-search-word regexp))
  )

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
      (setf (nth 2 args) (replace-regexp-in-string "\n" " "
                                                   (replace-regexp-in-string "[ \t]*//[/*!]*[ \t]+" ""
                                                                             (replace-regexp-in-string "[ \t]+\\(\\*[ \t]+\\)+" " " text))))
      args))

  (advice-add 'google-translate-request :filter-args
              #'remove-c-comment)

  :config/el-patch
  (el-patch-defun google-translate--search-tkk ()
    "Search TKK."
    (el-patch-swap
      (let ((start nil)
            (tkk nil)
            (nums '()))
        (setq start (search-forward ",tkk:'"))
        (search-forward "',")
        (backward-char 2)
        (setq tkk (buffer-substring start (point)))
        (setq nums (split-string tkk "\\."))
        (list (string-to-number (car nums))
              (string-to-number (car (cdr nums)))))
      (list 430675 2721866130)))
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
  (("C-'" . ace-window))
  :custom-face
  (aw-leading-char-face ((t (:height 3.0 :foreground "#f1fa8c"))))
  )

(use-package cargo)

(use-package rustic
  :after (lsp-mode cargo)
  :bind
  (:map rustic-mode-map
        ("C-c C-c C-r" . cargo-process-run))
  )
