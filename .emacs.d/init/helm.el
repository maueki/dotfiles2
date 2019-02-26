;; helm

(require 'helm)
(require 'helm-ls-git)

(when (require 'migemo nil 'noerror)
  (helm-migemo-mode +1))

(global-set-key (kbd "M-y") 'helm-show-kill-ring)
(global-set-key (kbd "C-x b") 'helm-for-files)
(global-set-key (kbd "C-x I") 'helm-semantic-or-imenu)
(global-set-key (kbd "C-x r l") 'helm-bookmarks)
(global-set-key (kbd "M-x") 'helm-M-x)
;(global-set-key (kbd "C-x C-f") 'helm-find-files)
(global-set-key (kbd "C-<f6>") 'helm-ls-git-ls)
(global-set-key (kbd "C-x C-d") 'helm-browse-project)

(custom-set-variables
 '(helm-source-ls-git (helm-ls-git-build-ls-git-source))
 '(helm-source-ls-git-status (helm-ls-git-build-git-status-source))
 '(helm-for-files-preferred-list
   '(helm-source-buffers-list
     helm-source-recentf
     helm-source-files-in-current-dir
     helm-source-ls-git-status
     helm-source-ls-git
     helm-source-file-cache
     helm-source-locate
     ))
 )
