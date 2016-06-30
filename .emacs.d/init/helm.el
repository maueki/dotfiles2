;; helm

(require 'helm)
(require 'helm-ls-git)

(global-set-key (kbd "M-y") 'helm-show-kill-ring)
(global-set-key (kbd "C-x b") 'helm-for-files)
(global-set-key (kbd "C-x I") 'helm-imenu)
(global-set-key (kbd "C-x r l") 'helm-bookmarks)

(setq helm-for-files-preferred-list
      '(helm-source-buffers-list
	helm-source-ls-git
        helm-source-recentf
        helm-source-file-cache
        ;; helm-source-files-in-current-dir
        helm-source-locate))

