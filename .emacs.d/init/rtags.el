
(when (require 'rtags nil 'noerror)
  (progn
    (add-hook 'c-mode-common-hook
              (lambda ()
                (when (rtags-is-indexed)
                  (local-set-key (kbd "M-.") 'rtags-find-symbol-at-point)
                  (local-set-key (kbd "M-;") 'rtags-find-symbol)
                  (local-set-key (kbd "M-r") 'rtags-find-references)
                  (local-set-key (kbd "M-*") 'rtags-location-stack-back))))
    (my-adapt-coding-system-with-current-buffer rtags-find-symbols-by-name-internal)
    (custom-set-variables '(rtags-use-helm t))
    ))




