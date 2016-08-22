(when (require 'mozc nil 'noerror)
  (progn
    (setq default-input-method "japanese-mozc")
    ;(global-set-key (kbd "C-'") 'toggle-input-method)
    (setq mozc-candidate-style 'echo-area)))
