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
        (when (re-search-forward "^project(\\([^ ]+\\)" nil t)
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

(require 'company)
(global-company-mode 1)

(require 'eglot)
(add-hook 'c-mode-hook 'eglot-ensure)
(add-hook 'c++-mode-hook 'eglot-ensure)

(load "D:/msys64/mingw64/share/clang/clang-format.el")
(global-set-key (kbd "C-<tab>") 'clang-format-region)

(setq clang-format-style "file")

(define-derived-mode empty-mode prog-mode "empty")

(add-to-list 'auto-mode-alist '("\\.c\\'" . empty-mode) t)
(add-to-list 'auto-mode-alist '("\\.h\\'" . empty-mode) t)
(add-to-list 'auto-mode-alist '("\\.cpp\\'" . empty-mode) t)
(add-to-list 'auto-mode-alist '("\\.hpp\\'" . empty-mode) t)

(provide 'empty-mode)
