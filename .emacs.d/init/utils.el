(defun open-in-browser()
  (interactive)
  (let ((filename (buffer-file-name)))
    (browse-url-generic (concat "file://" filename))))

; 現在開いているバッファのディレクトリをtmuxで開く
(defun tmux-new-window ()
  (interactive)
  (let ((fname buffer-file-name))
    (if (stringp fname)
        (shell-command (concat "tmux new-window -c \"$(dirname " fname ")\"")))))
