
(defun cargo-atcoder-test()
  (interactive)
  (let ((test-name (file-name-base (buffer-file-name))))
    (progn
      (compile (concat "cargo atcoder test " test-name))
      )))

;(defun cargo-atcoder-submit()
;  (interactive)
;  (let ((test-name (file-name-base (buffer-file-name))))
;    (progn
;      (compile (concat "cargo atcoder submit --bin " test-name))
;      )))

(defun cargo-atcoder-submit()
  (interactive)
  (require 'term)
  (let* ((process-name "cargo atcoder submit")
         (buffer-name (concat "*" process-name "*")))
    (when (buffer-live-p (get-buffer buffer-name))
        (kill-buffer buffer-name))
    (cd "../../") ; cd to cargo root
    (let* ((test-name (file-name-base (buffer-file-name)))
           (cmd "cargo")
           (args (concat "atcoder submit --bin --force " test-name))
           (switches (split-string-and-unquote args))
           (termbuf (apply 'make-term process-name cmd nil switches)))
      (with-current-buffer termbuf
        (term-mode)
        (term-char-mode))
      (display-buffer termbuf '(nil (allow-no-window . t))))))

(defun cargo-atcoder-open-problem()
  (interactive)
  (let ((bfn (buffer-file-name)))
    (string-match "\\([^/]+\\)/src/bin/\\([^/]+\\)\\.rs$" bfn)
    (let ((problem-name (match-string 2 bfn))
          (contest-name (match-string 1 bfn)))
      (browse-url-generic (concat "https://atcoder.jp/contests/" contest-name "/tasks/" contest-name "_" problem-name)))))

(defvar cargo-atcoder-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "C-c C-t") 'cargo-atcoder-test)
    (define-key map (kbd "C-c C-s") 'cargo-atcoder-submit)
    (define-key map (kbd "C-c C-p") 'cargo-atcoder-open-problem)
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
