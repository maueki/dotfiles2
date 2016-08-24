;; helm

(require 'helm)
(require 'helm-ls-git)

(when (require 'migemo nil 'noerror)
  (helm-migemo-mode +1))

(global-set-key (kbd "M-y") 'helm-show-kill-ring)
(global-set-key (kbd "C-x b") 'helm-mini)
(global-set-key (kbd "C-x I") 'helm-imenu)
(global-set-key (kbd "C-x r l") 'helm-bookmarks)
(global-set-key (kbd "M-x") 'helm-M-x)
;(global-set-key (kbd "C-x C-f") 'helm-find-files)

(setq helm-mini-default-sources
      '(helm-source-buffers-list
        helm-source-ls-git
        helm-source-recentf
        helm-source-file-cache
        ;; helm-source-files-in-current-dir
        helm-source-locate))
