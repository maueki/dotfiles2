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

(require 'whitespace)
(set-face-foreground 'whitespace-space "aaaaaa")
(set-face-background 'whitespace-space 'nil)
(set-face-foreground 'whitespace-tab "#444444")
(set-face-background 'whitespace-tab 'nil)
(global-whitespace-mode 1)
