(setq custom-file "~/.emacs.d/.init.custom.el")
(load-file custom-file)

(tool-bar-mode 0)
(menu-bar-mode 0)
(scroll-bar-mode 0)
(ido-mode 1)
(ido-everywhere 1)
(global-display-line-numbers-mode 1)
(delete-selection-mode 1)

(setq msys2-mingw64 "D:/msys64/mingw64/bin")
(setq cmake-path "D:/Cmake/bin")
(add-to-list 'exec-path msys2-mingw64)
(add-to-list 'exec-path cmake-path)
(setenv "PATH" (concat msys2-mingw64 ";" cmake-path ";" (getenv "PATH")))

(setq display-buffer-alist
      '(("\\*compilation\\*"
         (display-buffer-below-selected)
         (window-height . 0.3))))
(setq compilation-scroll-output t)

(global-set-key [f11] 'toggle-frame-fullscreen)

(setenv "CC" "gcc")
(setenv "CXX" "g++")
(defvar my-last-source-dir nil "保存 F5 的源码目录")
(defvar my-project-name nil "自动读取的 CMake ProjectName")

(defun my-compile (&optional cmake-dir)
  (interactive "sInput CMakeLists.txt Dir (default[current dir]): ")
  (let* ((source-dir (if (or (null cmake-dir) (string-empty-p (string-trim cmake-dir)))
                         "."
                       (string-trim cmake-dir)))
         (abs-source-dir (expand-file-name source-dir))
         (cmake-file (concat (file-name-as-directory abs-source-dir) "CMakeLists.txt"))
         (name ""))
    (setq my-last-source-dir abs-source-dir)
    (when (file-exists-p cmake-file)
      (with-temp-buffer
        (insert-file-contents cmake-file)
        (goto-char (point-min))
        (when (re-search-forward "^project(\$[^ ]+\$" nil t)
          (setq name (match-string 1))
          (setq my-project-name name))))
    (compile (format "cmake -B %s/build -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -G \"MinGW Makefiles\" -S %s && mingw32-make -C %s/build"
                     abs-source-dir abs-source-dir abs-source-dir))))
(global-set-key (kbd "<f5>") 'my-compile)

(defun my-build ()
  (interactive)
  (if (not my-last-source-dir)
      (error "先按 F5 初始化项目！")
    (compile (format "mingw32-make -C %s/build" my-last-source-dir))))
(global-set-key (kbd "<f6>") 'my-build)

(defun my-run ()
  (interactive)
  (cond
   ((not my-last-source-dir)
    (error "先按 F5 编译一次！"))
   ((not my-project-name)
    (error "无法读取项目名，请检查 CMakeLists.txt"))
   (t
    (let* ((abs-dir (expand-file-name my-last-source-dir))
           (exe-path (concat (file-name-as-directory abs-dir)
                             "build/" my-project-name ".exe")))
      (message "运行程序：%s" exe-path)
      (shell-command exe-path)))))
(global-set-key (kbd "<f7>") 'my-run)

;; ============================================================
;; C / C++ 编码风格 — Allman 4空格（按官方示例配置）
;; ============================================================

(require 'cc-mode)

;; 1. c-initialization-hook: 绑定回车键到 c-context-line-break
;;    这是官方推荐做法，避免 electric-indent 重新缩进上一行
(defun my-c-initialization-hook ()
  (define-key c-mode-base-map "\C-m" 'c-context-line-break))
(add-hook 'c-initialization-hook 'my-c-initialization-hook)

;; 2. 定义个人风格（按官方 sample .emacs 方式）
(defconst my-c-style
  '((c-tab-always-indent        . t)
    (c-comment-only-line-offset . 4)
    (c-hanging-braces-alist     . ((substatement-open before after)
                                   (defun-open before after)
                                   (class-open before after)
                                   (inline-open before after)
                                   (block-open before after)
                                   (brace-list-open before after)
                                   (statement-case-open before after)))
    (c-hanging-colons-alist     . ((member-init-intro before)
                                   (inher-intro)
                                   (case-label after)
                                   (label after)
                                   (access-label after)))
    (c-cleanup-list             . (scope-operator
                                   empty-defun-braces
                                   defun-close-semi
                                   brace-else-brace
                                   brace-elseif-brace))
    (c-offsets-alist            . ((substatement-open . 0)
                                   (defun-open . 0)
                                   (defun-block-intro . +)
                                   (statement-block-intro . +)
                                   (block-close . 0)
                                   (inline-open . 0)
                                   (class-open . 0)
                                   (inclass . +)
                                   (access-label . -)
                                   (statement-case-open . 0)
                                   (case-label . 0)
                                   (brace-list-open . 0)
                                   (arglist-close . c-lineup-arglist)
                                   (knr-argdecl-intro . -)))
    (c-echo-syntactic-information-p . t))
  "Allman 4-space C/C++ Style")
(c-add-style "ALLMAN4" my-c-style)

;; 3. c-mode-common-hook: 应用风格 + 缩进设置
(defun my-c-mode-common-hook ()
  ;; 应用个人风格
  (c-set-style "ALLMAN4")
  ;; 缩进设置
  (setq c-basic-offset 4
        tab-width 4
        indent-tabs-mode nil)
  ;; 开启 auto-newline（输入 { ; } 自动排版换行）
  (c-toggle-auto-newline 1)
  ;; 诊断
  (message "=== CC-MODE: style=%s offset=%d tab=%d ==="
           c-indentation-style c-basic-offset tab-width))
(add-hook 'c-mode-common-hook 'my-c-mode-common-hook)

;; 4. 强制用传统 cc-mode（禁止 Emacs 29+ 切到 ts-mode）
(setq major-mode-remap-alist
      '((c-mode . c-mode)
        (c++-mode . c++-mode)
        (java-mode . java-mode)))

;; 5. 默认风格
(setq c-default-style '((java-mode . "java")
                        (awk-mode . "awk")
                        (other . "ALLMAN4")))

;; 6. eglot 防覆盖
(defun my-eglot-ensure-style (&rest _)
  (when (derived-mode-p 'c-mode 'c++-mode)
    (c-set-style "ALLMAN4")
    (setq c-basic-offset 4
          tab-width 4
          indent-tabs-mode nil)
    (c-toggle-auto-newline 1)))
(add-hook 'eglot-managed-mode-hook 'my-eglot-ensure-style)
;; ============================================================

(require 'company)
(global-company-mode 1)

(require 'eglot)
(setq eglot-format-on-save nil)
(add-hook 'c-mode-hook 'eglot-ensure)
(add-hook 'c++-mode-hook 'eglot-ensure)

(setq search-invisible t)
