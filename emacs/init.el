(setq custom-file "~/.emacs.d/.init.custom.el")
(load-file custom-file)

(tool-bar-mode 0)
(menu-bar-mode 0)
(scroll-bar-mode 0)
(ido-mode 1)
(ido-everywhere 1)
(global-display-line-numbers-mode 1)
(show-paren-mode 1)

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
(defun my-compile ()
  (interactive)
  (compile "cmake -B build -G \"MinGW Makefiles\" && mingw32-make -C build"))
(global-set-key (kbd "<f6>") 'my-compile)
