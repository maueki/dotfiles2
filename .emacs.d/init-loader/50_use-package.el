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
  (company-minimum-prefix-length 1)
  (company-selection-wrap-around t)
  :diminish company-mode)


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
  (lsp-clients-clangd-executable "/usr/bin/clangd")
  (lsp-clients-clangd-args '("--background-index"
                              "--clang-tidy"
                              "--completion-style=detailed"
                              "--header-insertion=never"))
  (lsp-completion-provider :capf)
  (lsp-use-plists t)
  ;; rust-analyzer
  (lsp-rust-analyzer-cargo-watch-command "clippy")
  (lsp-rust-analyzer-proc-macro-enable t)
  (lsp-rust-analyzer-display-parameter-hints t)
  (lsp-rust-analyzer-display-chained-hint t)
  :hook
  (c-mode   . lsp)
  (c++-mode . lsp)
  (lsp-mode . lsp-inlay-hints-mode)
  :init
  ;; emacs-lsp-booster: LSPのJSONパースをRustプロキシで高速化
  (defun lsp-booster--advice-json-parse (old-fn &rest args)
    (or (when (equal (following-char) ?#)
          (let ((bytecode (read (current-buffer))))
            (when (byte-code-function-p bytecode)
              (funcall bytecode))))
        (apply old-fn args)))
  (advice-add (if (progn (require 'json)
                         (fboundp 'json-parse-buffer))
                  'json-parse-buffer
                'json-read)
              :around #'lsp-booster--advice-json-parse)
  (defun lsp-booster--advice-final-command (old-fn cmd &optional test?)
    (let ((orig-result (funcall old-fn cmd test?)))
      (if (and (not test?)
               (not (file-remote-p default-directory))
               lsp-use-plists
               (not (functionp 'json-rpc-connection))
               (executable-find "emacs-lsp-booster"))
          (progn
            (message "Using emacs-lsp-booster for %s!" orig-result)
            (cons "emacs-lsp-booster" orig-result))
        orig-result)))
  (advice-add 'lsp-resolve-final-command :around #'lsp-booster--advice-final-command)
  (setq lsp-auto-guess-root t)
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
    (lsp-ui-doc-show-with-cursor 't)
    (lsp-ui-doc-max-height 20)
    :bind (("C-c z" . lsp-ui-doc-focus-frame))
    )
  ;; リモート用 clangd クライアントを登録
  (lsp-register-client
   (make-lsp-client
    :new-connection (lsp-tramp-connection "clangd") ;; リモート側の clangd を使う
    :major-modes '(c-mode c++-mode objc-mode)       ;; C/C++ 等
    :remote? t                                      ;; リモート用であることを指定
    :server-id 'clangd-remote))
  )

(use-package cmake-mode)


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
  (python-mode . py-autopep8-mode)
)

(use-package sphinx-doc
  :hook (python-mode . sphinx-doc-mode))

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

(use-package rustic
  :custom
  (rustic-lsp-client 'lsp-mode)
  (rustic-format-on-save t)
  (rustic-cargo-use-last-stored-arguments t)
  :bind (:map rustic-mode-map
              ("C-c C-o"     . lsp-rust-analyzer-open-external-docs)
              ("C-c C-c C-r" . rustic-cargo-run)
              ("C-c C-c C-t" . rustic-cargo-test)
              ("C-c C-c C-c" . rustic-cargo-clippy)))

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

(use-package js2-mode
  :mode ("\\.js\\'" . js2-mode)
  :config
  (setq js-indent-level 2
        js2-basic-offset 2
        js2-strict-missing-semi-warning nil))

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
