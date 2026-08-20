;; remove #xxx#, xxx~
(setq create-lockfiles nil)
(setq auto-save-default nil)
(setq make-backup-files nil)
(setq tramp-auto-save-directory "/tmp")

;; appearance
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(delete-selection-mode 1)
(global-display-line-numbers-mode)
(show-paren-mode t)
(global-hl-line-mode 1)
(set-face-background 'hl-line "#282828")
(setq inhibit-startup-screen t)
(setq display-line-numbers-type 'relative)
(setq display-line-numbers-width 4)
(setq display-line-numbers-grow-only nil)
(setq display-line-numbers-width-start t)
(setq query-replace-highlight t)

;; scroll
(setq scroll-conservatively 10000)
(setq scroll-margin 3)
(setq scroll-preserve-screen-position t)
(setq mouse-wheel-scroll-amount '(1 ((shift) . 5)))

;; font
(set-face-attribute 'default nil
                    :family "Consolas"
		    :height 220)
;;(setq-default line-spacing 0.11)
(dolist (charset '(han kana symbol cjk-misc bopomofo))
  (set-fontset-font (frame-parameter nil 'font) charset
                    (font-spec :family "LXGW WenKai" :size 20)))

;; interact
(setq-default case-fold-search t)
(setq use-short-answers t)

;; code
(setq-default indent-tabs-mode nil
              tab-width 4
              standard-indent 4
              c-basic-offset 4
	      prefer-coding-system 'utf-8-unix)
(global-auto-revert-mode t)
(electric-pair-mode t)

;; company
(setq company-backends '(
                         company-capf
                         company-dabbrev-code
                         company-files
                         company-keywords))
                         ;;company-ispell))

;; ghost font color
(with-eval-after-load 'company
(set-face-attribute 'company-preview nil
                    :foreground "#73c936"
                    :background (if (facep 'hl-line)
                                    (face-background 'hl-line)
                                  (face-background 'default))))

;; compile
(require 'compile)
(add-to-list 'compilation-error-regexp-alist
             '("\\([a-zA-Z0-9\\.]+\\)(\\([0-9]+\\)\\(,\\([0-9]+\\)\\)?) \\(Warning:\\)?"
               1 2 (4) (5)))
(setq compile-command "make -j8")

(provide 'core)
