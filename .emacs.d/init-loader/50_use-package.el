(use-package counsel
  :after ivy
  :bind (("<f4>" . counsel-git-grep)
         ("C-x m" . counsel-mark-ring)
         ("C-x f" . counsel-git))
  :config (counsel-mode)
;  (defun ad:counsel-git-grep (&rest args)
;    (set-mark-command args)
;    (deactivate-mark))
;  (advice-add 'counsel-git-grep :before #'ad:counsel-git-grep)
)

(use-package ivy
  :defer 0.1
  :diminish
  :bind (("C-c C-r" . ivy-resume)
         ("C-x B" . ivy-switch-buffer-other-window))
  :custom
  (ivy-count-format "(%d/%d) ")
  (ivy-use-virtual-buffers t)
  :config (ivy-mode))

(use-package swiper
  :after ivy
  :bind (("C-s" . swiper)
         ("C-r" . swiper)))

;(when (require 'migemo nil 'noerror)
;  (helm-migemo-mode +1))

; Avoid `symbol's value as variable is void: project-switch-commands"` in magit
; https://www.reddit.com/r/emacs/comments/po9cfj/magit_commands_broken/
(use-package project :straight t)

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
  (lsp-rust-server 'rust-analyzer)
  (lsp-enable-on-type-formatting nil) ; Enterで勝手にフォーマットしない
  :hook
  (rust-mode . lsp)
  :bind
  (:map lsp-mode-map
;        ("C-c r"   . lsp-rename)
        ("C-c C-c C-d"   . lsp-describe-thing-at-point)
        )
  :config
  ;; LSP UI tools
  (use-package lsp-ui
    :custom
    (lsp-ui-doc-position 'bottom)
    )
  ;; Lsp completion
  (use-package company-lsp
    :custom
    (company-lsp-cache-candidates t) ;; always using cache
    (company-lsp-async t)
    (company-lsp-enable-recompletion nil))
  )

;; cclsは別途hookする
(use-package ccls
  :custom (ccls-executable "/usr/bin/ccls")
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

(use-package pipenv
  :config
  ; https://github.com/jorgenschaefer/elpy/issues/1217
  (pyvenv-tracking-mode)
  :init
  (defun pipenv-auto-activate ()
    "Set `pyvenv-activate' to the current pipenv virtualenv.
     This function is intended to be used in parallel with
      `pyvenv-tracking-mode'."
    (pipenv-deactivate)
    (pipenv--force-wait (pipenv-venv))
    (when python-shell-virtualenv-root
      (setq-local pyvenv-activate
                  (directory-file-name python-shell-virtualenv-root))
      (setq-local python-shell-interpreter "pipenv")
      (setq-local python-shell-interpreter-args "run python")
      ))
  :hook (elpy-mode-hook . pipenv-auto-activate)
)

(use-package elpy
  :init
  (elpy-enable)
  :config
  ; e.g. https://mako-note.com/elpy-rpc-python-version/
  (setq elpy-rpc-python-command "python3")
  (setq python-shell-interpreter "pipenv"
        python-shell-interpreter-args "run python -i")
  )

(use-package py-autopep8
  :hook
  (python-mode . py-autopep8-enable-on-save)
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

;(use-package tramp
;  :config
;  (setq tramp-copy-size-limit nil)
;  (setq tramp-inline-compress-start-size nil)
;  (setq password-cache-expiry nil)
;)

(use-package sudo-edit)

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

  ;; disable at 2022/12/29: `google-translate--search-tkk` no found
  ;; :config/el-patch
  ;; (el-patch-defun google-translate--search-tkk ()
  ;;   "Search TKK."
  ;;   (el-patch-swap
  ;;     (let ((start nil)
  ;;           (tkk nil)
  ;;           (nums '()))
  ;;       (setq start (search-forward ",tkk:'"))
  ;;       (search-forward "',")
  ;;       (backward-char 2)
  ;;       (setq tkk (buffer-substring start (point)))
  ;;       (setq nums (split-string tkk "\\."))
  ;;       (list (string-to-number (car nums))
  ;;             (string-to-number (car (cdr nums)))))
  ;;     (list 430675 2721866130)))
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
  (("C-;" . ace-window))
  :custom
  (aw-dispatch-when-more-than 3)
  :custom-face
  (aw-leading-char-face ((t (:height 3.0 :foreground "#f1fa8c"))))
  )

(use-package point-undo
  :bind (([f7] . point-undo)
         ([M-f7] . point-redo))
)

(use-package cargo
  :hook (rust-mode . cargo-minor-mode)
  )

(use-package rust-mode
  :bind (("C-c C-o" . lsp-rust-analyzer-open-external-docs))
  )

;(use-package rustic
;  :after (cargo)
;  :bind
;  (:map rustic-mode-map
;        ("C-c C-c C-r" . cargo-process-run)
;        ("C-c C-c C-t" . cargo-process-test)
;        )
;  :config
;  (setq lsp-rust-analyzer-server-command '("~/.local/bin/rust-analyzer"))
;  (setq rustic-lsp-server 'rust-analyzer)
;  )

(use-package web-mode
  :mode
  (
   ".html?$"
   ".vue$"
  )
  )

(use-package dart-mode
  :custom
  (dart-format-on-save t)
  (dart-sdk-path "~/snap/flutter/common/flutter/bin/cache/dart-sdk/"))

(use-package flutter
  :after dart-mode
  :bind (:map dart-mode-map
              ("C-M-x" . #'flutter-run-or-hot-reload))
  :custom
  (flutter-sdk-path "~/snap/flutter/common/flutter/")
  :hook (dart-mode . (lambda ()
                          (add-hook 'after-save-hook #'flutter-run-or-hot-reload nil t))))

;(use-package lsp-pyright
;  :hook (python-mode . (lambda ()
;                          (require 'lsp-pyright)
;                          (lsp))))  ; or lsp-deferred

(use-package rjsx-mode
  :mode (("\\.js\\'" . rjsx-mode))
)

; https://qiita.com/nuy/items/ebcb25ad14f02ab72790
(use-package typescript-mode
  :config
  (setq typescript-indent-level 2)
  (add-hook 'typescript-mode-hook
          (lambda ()
            (interactive)
            (mmm-mode)
            )))

(use-package mmm-mode
  :commands mmm-mode
  :mode (("\\.tsx\\'" . typescript-mode))
  :config
  (setq mmm-global-mode t)
  (setq mmm-submode-decoration-level 0)
  (mmm-add-classes
   '((mmm-jsx-mode
      :submode web-mode
      :face mmm-code-submode-face
      :front "\\(return\s\\|n\s\\|(\n\s*\\)<"
      :front-offset -1
      :back ">\n?\s*)\n}\n"
      :back-offset 1
      )))
  (mmm-add-mode-ext-class 'typescript-mode nil 'mmm-jsx-mode)


  (defun mmm-reapply ()
    (mmm-mode)
    (mmm-mode))

  (add-hook 'after-save-hook
            (lambda ()
              (when (string-match-p "\\.tsx?" buffer-file-name)
                (mmm-reapply)
                )))
  )
