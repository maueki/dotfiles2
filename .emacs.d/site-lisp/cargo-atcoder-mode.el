
(defun cargo-atcoder-test()
  (interactive)
  (let ((test-name (file-name-base (buffer-file-name))))
    (progn
      (compile (concat "cargo atcoder test " test-name))
      )))

(defun cargo-atcoder-submit()
  (interactive)
  (let ((test-name (file-name-base (buffer-file-name))))
    (progn
      (compile (concat "cargo atcoder submit --bin " test-name))
      )))

(defvar cargo-atcoder-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "C-c C-t") 'cargo-atcoder-test)
    (define-key map (kbd "C-c C-s") 'cargo-atcoder-submit)
    map)
  "Keymap used in `cargo-atcode-mode'.")

(define-minor-mode cargo-atcoder-mode
  "atcoder mode for rust-lang"
  :init-value nil
  :lighter "cargo atcoder"
  :keymap nil
  :group 'cargo-atcoder-mode
  )

(provide 'cargo-atcoder-mode)
