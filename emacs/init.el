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
(setq cmake "D:/Cmake/bin")
(setq exec-path (list msys2-mingw64 cmake "C:/Windows/System32"))
(setenv "PATH" (concat msys2-mingw64 ";" cmake ";C:\\Windows\\System32"))

(setq display-buffer-alist
      '(("\\*compilation\\*"
         (display-buffer-below-selected)
         (window-height . 0.3))))
(setq compilation-scroll-output t)

(global-set-key [f11] 'toggle-frame-fullscreen)

(setenv "CC" "gcc")
(setenv "CXX" "g++")
(defun my-compile (&optional cmake-dir)
  (interactive "sInput CMakeLists.txt Dir (default[current dir]): ")
  (let ((source-dir (if (or (null cmake-dir) (string-empty-p (string-trim cmake-dir)))
                        "."
                      (string-trim cmake-dir))))
    (compile (format "cmake -B build -G \"MinGW Makefiles\" -S %s && mingw32-make -C build"
                      source-dir))))
(global-set-key (kbd "<f5>") 'my-compile)

(defun my-build ()
  (interactive)
  (compile "mingw32-make -C build"))
(global-set-key (kbd "<f6>") 'my-build)

(defun my-run()
  (interactive)
  (let ((name (read-string "sInput app name: ")))
    (shell-command (concat ".\\build\\" name ".exe"))))
(global-set-key (kbd "<f7>") 'my-run)

(require 'company)
(global-company-mode 1)
(setq company-idle-delay 0.1)
(setq company-minimum-prefix-length 1)
(define-key company-active-map (kbd "TAB") 'company-complete)
(define-key company-active-map (kbd "<return>") 'company-complete-selection)

(setq c-default-style "linux")
(setq c-basic-offset 4)
(setq tab-width 4)
(setq-default indent-tabs-mode nil)

(add-hook 'c-mode-hook
          (lambda ()
            (setq c-basic-offset 4)
            (setq indent-tabs-mode nil)))

(add-hook 'c++-mode-hook
          (lambda ()
            (setq c-basic-offset 4)
            (setq indent-tabs-mode nil)))

(require 'eglot)
(add-hook 'c++-mode-hook 'eglot-ensure)
(add-hook 'c-mode-hook 'eglot-ensure)
