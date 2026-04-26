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

;;; Markdown → PDF → doc-view preview
(defvar my/md-pdf-view-buffer nil)

(defun my/md-preview-pdf ()
  "Convert markdown to PDF with pandoc and display in doc-view."
  (interactive)
  (unless (buffer-file-name)
    (user-error "Save the buffer first"))
  (let* ((md-file  (buffer-file-name))
         (pdf-file (concat (file-name-sans-extension md-file) ".pdf"))
         (md-buf   (current-buffer)))
    (my/md-to-pdf md-file pdf-file)
    (let ((win (selected-window))
          (pdf-buf (find-file-noselect pdf-file)))
      (setq my/md-pdf-view-buffer pdf-buf)
      (display-buffer pdf-buf '(display-buffer-use-some-window . ((inhibit-same-window . t)))))
    (add-hook 'after-save-hook #'my/md-preview-pdf-on-save nil t)
    (message "PDF preview started. Auto-updates on save.")))

(defun my/md-preview-pdf-on-save ()
  (when (buffer-file-name)
    (let ((pdf-file (concat (file-name-sans-extension (buffer-file-name)) ".pdf")))
      (my/md-to-pdf (buffer-file-name) pdf-file)
      (when (buffer-live-p my/md-pdf-view-buffer)
        (with-current-buffer my/md-pdf-view-buffer
          (doc-view-revert-buffer nil t))))))

(defun my/md-to-pdf (md-file pdf-file)
  (message "Rendering PDF...")
  (let ((exit-code
         (call-process "pandoc" nil "*pandoc-pdf*" nil
                       "-f" "markdown+tex_math_single_backslash"
                       "--pdf-engine=xelatex"
                       "-V" "documentclass=article"
                       "-V" "geometry=margin=2cm"
                       "-V" "CJKmainfont=IPAGothic"
                       "-o" pdf-file md-file)))
    (if (zerop exit-code)
        (message "PDF rendered.")
      (pop-to-buffer "*pandoc-pdf*")
      (user-error "pandoc failed (see *pandoc-pdf* buffer)"))))
