;; duplicate-line
(defun duplicate-line ()
  "Duplicate current line"
  (interactive)
  (let ((column (- (point) (point-at-bol)))
        (line (let ((s (thing-at-point 'line t)))
                (if s (string-remove-suffix "\n" s) ""))))
    (move-end-of-line 1)
    (newline)
    (insert line)
    (move-beginning-of-line 1)
    (forward-char column)))
(global-set-key (kbd "C-.") 'duplicate-line)

;; mark whole line
(defun mark-whole-line ()
  "Mark whole current line"
  (interactive)
  (beginning-of-line)
  (set-mark (point))
  (end-of-line)
  (activate-mark))
(global-set-key (kbd "C-S-z") 'mark-whole-line)

;; indent 4
(defun my-rigid-indent-forward-4 ()
  (interactive)
  (if (use-region-p)
      (indent-rigidly (region-beginning) (region-end) 4)
    (indent-rigidly (line-beginning-position) (line-end-position) 4)))
(defun my-rigid-indent-backward-4 ()
  (interactive)
  (if (use-region-p)
      (indent-rigidly (region-beginning) (region-end) -4)
    (indent-rigidly (line-beginning-position) (line-end-position) -4)))
(global-set-key (kbd "C-<tab>")    'my-rigid-indent-forward-4)
(global-set-key (kbd "C-<iso-lefttab>")  'my-rigid-indent-backward-4)

;; ansi-color
(require 'ansi-color)
(add-hook 'compilation-filter-hook #'ansi-color-compilation-filter)

;; md auto wrap
(add-hook 'markdown-mode-hook #'visual-line-mode)

(provide'functions)
