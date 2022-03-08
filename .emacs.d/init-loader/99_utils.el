(defun x-clipboard-copy ()
  (interactive)
  (when (region-active-p)
    (shell-command-on-region (region-beginning) (region-end) "xsel -ib" nil nil)))

(defun open-in-browser()
  (interactive)
  (let ((filename (buffer-file-name)))
    (browse-url-generic (concat "file://" filename))))

; 現在開いているバッファのディレクトリをtmuxで開く
(defun tmux-new-window ()
  (interactive)
  (if (string-equal major-mode "dired-mode")
      (let ((dirname (expand-file-name default-directory)))
        (shell-command (concat "tmux new-window -c \"" dirname "\"")))
    (let ((fname buffer-file-name))
      (if (stringp fname)
          (shell-command (concat "tmux new-window -c \"$(dirname " fname ")\""))))))

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
         '(100 . 100) '(90 . 90)))))
(global-set-key (kbd "C-c C-t") 'toggle-transparency)
(toggle-transparency)

(global-set-key (kbd "C-x I") 'imenu)
