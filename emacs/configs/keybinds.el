;; keybinds
(global-set-key (kbd "<f5>") #'compile)
(global-set-key (kbd "C-c d") 'kill-whole-line)
(global-set-key (kbd "C-z") 'set-mark-command)
(global-set-key (kbd "C-M-z") 'rectangle-mark-mode)
;; comment
(global-set-key (kbd "M-;") 'comment-dwim)
;; goto line
(global-set-key (kbd "C-c g") 'goto-line)

;; window move
(global-set-key (kbd "C-S-<left>")  'windmove-left)
(global-set-key (kbd "C-S-<down>")  'windmove-down)
(global-set-key (kbd "C-S-<up>")    'windmove-up)
(global-set-key (kbd "C-S-<right>") 'windmove-right)

(provide 'keybinds)
