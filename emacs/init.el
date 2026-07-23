1;;使用msys2
;;    gcc g++ clangd neocmakelsp

;;通用设置
(tool-bar-mode 0)
(menu-bar-mode 0)
(scroll-bar-mode 0)
(ido-mode 1)
(ido-everywhere 1)
(global-display-line-numbers-mode 1)
(delete-selection-mode 1)
(setq inhibit-startup-message t)
(setq create-lockfiles nil)
(setq auto-save-default nil)
(setq make-backup-files nil)
(setq scroll-conservatively 10000)
(setq scroll-margin 3)
(setq scroll-preserve-screen-position t)
(setq mouse-wheel-scroll-amount '(1 ((shift) . 5)))
(setq display-line-numbers-width 4)
(setq display-line-numbers-grow-only nil)
(setq display-line-numbers-width-start t)

;; 查找CMake根目录
(defun my-find-cmake-root ()
  (let ((dir (expand-file-name default-directory)))
    (while (and dir (not (file-exists-p (concat dir "/CMakeLists.txt"))))
      (setq dir (file-name-directory (directory-file-name dir)))
      (when (equal dir "/")
        (setq dir nil)))
    dir))

;; 提取项目名
(defun my-get-cmake-project-name (root-dir)
  (let ((cmfile (concat root-dir "/CMakeLists.txt")))
    (with-temp-buffer
      (insert-file-contents cmfile)
      (goto-char (point-min))
      (if (re-search-forward "^[[:space:]]*project\\s*(" nil t)
          (progn
            (forward-char 1)
            (skip-chars-forward " \t")
            (let ((start (point)))
              (skip-chars-forward "a-zA-Z0-9_-")
              (buffer-substring-no-properties start (point))))
        nil))))

;; F5 编译（compilation窗口，自带chcp 65001）
(defun my-cmake-build ()
  (interactive)
  (unless (fboundp 'my-find-cmake-root)
    (message "错误：编译工具函数未加载，请重载配置文件")
    (return))
  (let ((root (my-find-cmake-root)))
    (if root
        (let ((build-cmd
               (if (eq system-type 'windows-nt)
                   (concat "cd " (shell-quote-argument root) " && chcp 65001 >nul 2>&1 && cmake -B build && cmake --build build")
                 (concat "cd " (shell-quote-argument root) " && cmake -B build && cmake --build build"))))
          (compile build-cmd))
      (message "错误：当前目录向上未找到 CMakeLists.txt"))))

;; F6 运行（输出缓冲窗口，自带chcp 65001）
(defun my-cmake-run ()
  (interactive)
  (unless (and (fboundp 'my-find-cmake-root) (fboundp 'my-get-cmake-project-name))
    (message "错误：编译工具函数未加载，请重载配置文件")
    (return))
  (let ((root (my-find-cmake-root)))
    (if (not root)
        (message "错误：未找到 CMakeLists.txt，无法定位程序")
      (let ((exe-name (my-get-cmake-project-name root)))
        (setq exe-name (or exe-name "YialiteTest"))
        (let* ((quoted-root (shell-quote-argument root))
               (quoted-exe (shell-quote-argument exe-name))
               (cmd
                (if (eq system-type 'windows-nt)
                    (concat "cd " quoted-root " && chcp 65001 >nul 2>&1 && .\\build\\" quoted-exe ".exe && pause")
                  (concat "cd " quoted-root " && ./build/" quoted-exe))))
          (shell-command cmd "*cmake-run-output*"))))))

;; 按键绑定
(define-key global-map (kbd "<f5>") #'my-cmake-build)
(define-key global-map (kbd "<f6>") #'my-cmake-run)

;;镜像源
(require 'package)
(setq package-archives
      '(("gnu"    . "https://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
        ("melpa"  . "https://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")
        ("nongnu" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/nongnu/")))

;;(package-initialize)
;;(package-refresh-contents)

;;自定义文件
(setq custom-file (expand-file-name "init.custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))

;;包
(dolist (pkg '(eglot company multiple-cursors cmake-mode move-text))
  (unless (package-installed-p pkg)
    (package-install pkg)))

;;多光标
(require 'multiple-cursors)
(global-set-key (kbd "C-S-<mouse-1>") 'mc/toggle-cursor-on-click)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)    ; 下一处同词加光标
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this); 上一处同词加光标
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this) ; 全文所有同词全部加光标
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)

;;补全库
(require 'company)
(global-company-mode 1)
(setq company-minimum-prefix-length 2)
(setq company-idle-delay 0.2)
(setq company-tooltip-align-annotations t)
(setq company-selection-wrap-around t)
(setq company-show-numbers t)

(define-key company-active-map (kbd "TAB") #'company-select-next)
(define-key company-active-map (kbd "<backtab>") #'company-select-previous)
(define-key company-active-map (kbd "RET") 'company-complete-selection)

(setq company-backends '(company-capf company-dabbrev company-files company-keywords))

;;语言服务
(require 'eglot)
(setq eglot-server-programs
      '((c-mode . ("clangd"))
        (c++-mode . ("clangd"))
        (cmake-mode . ("neocmakelsp" "stdio")))) ;;有bug
(add-hook 'c-mode-hook 'eglot-ensure)
(add-hook 'c++-mode-hook 'eglot-ensure)
(setq eglot-confirm-signature-help-chars nil)
(setq eglot-autoshutdown t)
(setq eglot-send-changes-idle-time 0.05) ; 缩短同步延迟，补全响应更快
(setq eglot-strict-indent nil)
(setq eglot-report-progress nil)
(setq flymake-no-changes-timeout 0.3)
(setq eglot-ignored-server-capabilities '(documentLinkProvider))
(setq eglot-event-log t)

;;cmake
(require 'cmake-mode)
(setq cmake-tab-width 4)
(setq cmake-indent-tabs-mode nil)
(add-hook 'cmake-mode-hook 'eglot-ensure)
(add-hook 'cmake-mode-hook
          (lambda ()
            (eglot-ensure)
            (setq-local company-minimum-prefix-length 1)
            (setq-local company-idle-delay 0.1)
            (setq-local company-backends '(company-capf company-keywords company-dabbrev company-files))
            (company-mode 1)
            (eldoc-mode 1)))

;;c/c++ mode
(setq c-basic-offset 4
      tab-width 4
      indent-tabs-mode nil)
(add-hook 'c-mode-hook
          (lambda ()
            (c-set-offset 'substatement-open 0)))
(add-hook 'c++-mode-hook
          (lambda ()
            (c-set-offset 'substatement-open 0)))

;;utf-8
;;(global-set-key (kbd "C-c c")
;;  (lambda ()
;;    (interactive)
;;   (when (eq system-type 'windows-nt)
;;      (comint-send-string (get-buffer-process (current-buffer)) "chcp 65001 >nul 2>&1\n"))))

;;pulse
(require 'pulse)
(defface pulse-save-line-face
  '((t :background "#4a4c53"))
  "Save pulse highlight.")
(defun pulse-line-after-save ()
  (interactive)
  (save-excursion
    (beginning-of-line)
    (let ((start (point)))
      (end-of-line)
      (pulse-momentary-highlight-region start (point) 'pulse-save-line-face))))
(add-hook 'after-save-hook #'pulse-line-after-save)
(setq pulse-delay 0.06)
(setq pulse-iterations 5)

;;move-text
(require 'move-text)
(global-set-key (kbd "M-p") 'move-text-up)
(global-set-key (kbd "M-n") 'move-text-down)

;;treesit
(setq treesit-font-lock-level 4)
(add-to-list 'major-mode-remap-alist '(c-mode . c-ts-mode))
(add-to-list 'major-mode-remap-alist '(c++-mode . c++-ts-mode))

;;highlight
(transient-mark-mode 1)
