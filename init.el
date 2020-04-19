;;;  package --- BasicSetting
(require 'package)
(add-to-list 'package-archives '("melpa" .  "https://melpa.org/packages/"))
(add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/"))
(package-initialize)

;; 如果未安裝 use-package，安裝它
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;; 使用 diminish (隱藏）及 bind-key 套件
(use-package diminish :ensure t)
(use-package bind-key :ensure t)

;; 使用自動更新套件
(use-package auto-package-update
  :ensure t
  :config
  (setq auto-package-update-delete-old-versions t)
  (setq auto-package-update-hide-results t)
  (auto-package-update-maybe))

;; 基本设定----
;; 關掉 menu-bar
(menu-bar-mode -1)

;; 顯示配對的括號
(show-paren-mode t)

;; set theme
(use-package zenburn-theme :ensure t)

;; 自動加入右括號及右 '
(electric-pair-mode t)
(setq electric-pair-pairs '(
			    (?\' . ?\')
			    ))
;; 不使用 tab
(setq-default indent-tabs-mode nil)

;; 移動視窗
(winner-mode t)

(setq custom-file "~/.emacs.d/custom-variables.el")
(when (file-exists-p custom-file)
    (load custom-file))

;; 設定自動儲存及備份目錄
(defconst emacs-tmp-dir (format "%s%s%s/" temporary-file-directory "emacs" (user-uid)))
(setq backup-directory-alist `((".*" . ,emacs-tmp-dir)))
(setq auto-save-file-name-transforms `((".*" ,emacs-tmp-dir t)))
(setq auto-save-list-file-prefix emacs-tmp-dir)

;; 二个常用的次模式
;;
;; hideshow
;;
(add-hook 'prog-mode-hook #'hs-minor-mode)

;;
;; multiple cursors
;;
(use-package multiple-cursors
  :ensure t
  :bind (
         ("M-3" . mc/mark-next-like-this)
         ("M-4" . mc/mark-previous-like-this)
         :map ctl-x-map
         ("\C-m" . mc/mark-all-dwim)
         ("<return>" . mule-keymap)
         ))

;; 安装ivy
(use-package ivy
  :ensure t
  :diminish (ivy-mode . "")
  :config
  (ivy-mode 1)
  (setq ivy-use-virutal-buffers t)
  (setq enable-recursive-minibuffers t)
  (setq ivy-height 10)
  (setq ivy-initial-inputs-alist nil)
  (setq ivy-count-format "%d/%d")
  (setq ivy-re-builders-alist
        `((t . ivy--regex-ignore-order)))
  )

;; Counsel
(use-package counsel
  :ensure t
  :bind (("M-x" . counsel-M-x)
         ("C-x C-f" . counsel-find-file)))
;; Swiper
(use-package swiper
  :ensure t
  :bind (("C-s" . swiper))
  )

;; 程式碼片段 (snippet)
(use-package yasnippet
  :ensure t
  :config
  (yas-global-mode)
  (use-package yasnippet-snippets :ensure t)
  )

;; 程式補全 (Code Complete)
(use-package company
  :ensure t
  :config
  (global-company-mode t)
  (setq company-idle-delay 0)
  (setq company-minimum-prefix-length 3)
  (setq company-backends
        '((company-files
           company-keywords
           company-capf
           company-yasnippet
           )
          (company-abbrev company-dabbrev))))
;; company-backends 可以在不同的主模式下設定不同的值
(add-hook 'emacs-lisp-mode-hook (lambda () 
            (add-to-list (make-local-variable 'company-backends) 
            '(company-elisp))))

;; 使用 Ctrl-n 跟 Ctrl-p 选择字串
(with-eval-after-load 'company
  (define-key company-active-map (kbd "\C-n") #'company-select-next)
  (define-key company-active-map (kbd "\C-p") #'company-select-previous)
  (define-key company-active-map (kbd "M-n") nil)
  (define-key company-active-map (kbd "M-p") nil))

;; Company 跟 Yasnippet 的 [tab]鍵衝突 的解决
(advice-add 'company-complete-common :before (lambda () 
                                (setq my-company-point (point))))
(advice-add 'company-complete-common :after (lambda () 
                                (when (equal my-company-point (point)) (yas-expand))))

;; 程式語法檢查
(use-package flycheck
  :ensure t
  :init
  (global-flycheck-mode t)
  )

;; 版本控制

(use-package magit
  :ensure t
  :bind (("\C-x g" . magit-status))
  )

;; server start settings
;; (server-start)
(setq server-socket-dir "~/.emacs.d/server")

;; 專案管理
(use-package projectile
  :ensure t
  :bind-keymap ("\C-c p" . projectile-command-map)
  :config
  (projectile-mode t)
  (setq projectile-completion-system 'ivy)
  (use-package counsel-projectile
    :ensure t)
  )

(use-package ag
  :ensure t)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                        ;                c/c++                ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(load "~/.emacs.d/custom/c.el")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                        ;                python               ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(load "~/.emacs.d/custom/python.el")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                        ;                R                   ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;(require 'ess-smart-underscore)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                        ;                 web                 ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(load "~/.emacs.d/custom/web.el")

(provide 'init)
;;; init.el ends here

