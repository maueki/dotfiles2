(when (require 'rtags nil 'noerror)
  (add-hook 'c-mode-common-hook
            (lambda ()
              (when (rtags-is-indexed)
                (local-set-key (kbd "M-.") 'rtags-find-symbol-at-point)
                (local-set-key (kbd "M-;") 'rtags-find-symbol)
                (local-set-key (kbd "M-r") 'rtags-find-references)
                (local-set-key (kbd "M-*") 'rtags-location-stack-back)))))

(custom-set-variables '(rtags-use-helm t))
