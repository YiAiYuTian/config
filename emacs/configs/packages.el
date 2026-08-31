;; magit
(use-package magit
  :ensure t
  :bind ("C-x g" . magit-status))

;; git-gutter
(use-package git-gutter
  :ensure t
  :hook (prog-mode . git-gutter-mode)
  :config
  (setq git-gutter:update-interval 0.1)
  (setq git-gutter:live-mode t)
  (global-git-gutter-mode t))

;; ido
(use-package ido
  :ensure nil
  :init
  (ido-mode t)
  :config
  (setq ido-enable-flex-matching t)
  (setq ido-everywhere t))

;; ido+
(use-package ido-completing-read+
  :ensure t
  :init
  (ido-ubiquitous-mode t))

;; smex
(use-package smex
  :ensure t
  :init
  (smex-initialize)
  :bind ("M-x" . smex))

;; move text
(use-package move-text
  :ensure t
  :bind (("M-p" . move-text-up)
         ("M-n" . move-text-down)))

;; multiple cursor
(use-package multiple-cursors
  :ensure t
  :bind (("C-c C-S-c"   . mc/edit-lines)
         ("C->"         . mc/mark-next-like-this)
         ("C-<"         . mc/unmark-next-like-this)
         ("C-c C->"     . mc/mark-all-like-this)
         ("C-\""        . mc/skip-to-next-like-this)))

;; dired-x
(require 'dired-x)
(setq dired-omit-files (concat dired-omit-files "\\|^\\..+$"))
(setq-default dired-dwim-target t)
(setq dired-listing-switches "-alh")
(setq dired-mouse-drag-files t)
(setq dired-kill-when-opening-new-dired-buffer t)

;; colorful-mode
(use-package colorful-mode
  :ensure t
  :config
  (global-colorful-mode t))

;; dimmer
(use-package dimmer
  :ensure t
  :config
  (dimmer-mode t)
  (setq dimmer-fraction 0.08)
  (setq dimmer-adjustment-mode :background))

;; eglot
(use-package eglot
  :ensure nil
  :hook (prog-mode . eglot-ensure)
  :config
  ;;(add-hook 'before-save-hook #'eglot-format)
  (add-to-list 'eglot-ignored-server-capabilities :semanticTokensProvider)
  (add-to-list 'eglot-server-programs
               '(cmake-mode . ("d:/msys64/home/20389/.venvs/cmake-lsp/Scripts/cmake-language-server.exe")))
  (setf (alist-get '(c-mode c++-mode) eglot-server-programs)
               '("clangd" "--header-insertion=never")))

;; company
(use-package company
  :ensure t
  :hook (after-init . global-company-mode)
  :custom
  (company-idle-delay 0.1)
  (company-minimum-prefix-length 2)
  (company-tooltip-align-annotations t)
  (company-show-quick-access t)
  :config
  (add-to-list 'company-frontends 'company-preview-frontend)
  (add-hook 'after-init-hook 'company-tng-mode))

;; pulse
(use-package pulse
  :ensure nil
  :custom
  (pulse-delay 0.06)
  (pulse-iterations 5)
  :config
  (defface pulse-save-line-face
    '((t :background "#4a4a40"))
    "Save pulse highlight.")
  (defun pulse-line-after-save ()
    (interactive)
    (save-excursion
      (beginning-of-line)
      (let ((start (point)))
        (end-of-line)
        (pulse-momentary-highlight-region start (point) 'pulse-save-line-face))))
  (add-hook 'after-save-hook #'pulse-line-after-save))

;; other-mode
(use-package lua-mode :ensure t)
(use-package csharp-mode :ensure t)
(use-package markdown-mode :ensure t)
(use-package yaml-mode :ensure t)
(use-package cmake-mode :ensure t)
(use-package rust-mode :ensure t)
(use-package json-mode :ensure t)
(use-package web-mode :ensure t)

(provide 'packages)
