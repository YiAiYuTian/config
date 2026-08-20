;; gnu melpa nongnu
;;(require 'package)
;;(setq use-package-always-ensure t)
;;(setq package-archives
;;      '(("gnu"    . "https://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
;;        ("melpa"  . "https://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")
;;        ("nongnu" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/nongnu/")))
;;
;;(package-initialize)
;;(package-refresh-contents)

;; custom file
(setq custom-file (expand-file-name "custom.el" (expand-file-name "configs/" user-emacs-directory)))
(when (file-exists-p custom-file)
  (load custom-file))
(add-to-list 'load-path (expand-file-name "configs/" user-emacs-directory))

;; configs
(require 'packages)
(require 'core)
(require 'functions)
(require 'keybinds)
