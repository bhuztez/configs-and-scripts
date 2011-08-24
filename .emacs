;;; display line number
(global-linum-mode t)

;;; hide toolbar
(tool-bar-mode nil) 

;;; http://stackoverflow.com/questions/815239/how-to-maximize-emacs-on-windows-at-startup
;;; x11-maximize-frame
(x-send-client-message nil 0 nil "_NET_WM_STATE" 32 '(2 "_NET_WM_STATE_MAXIMIZED_HORZ" 0))
(x-send-client-message nil 0 nil "_NET_WM_STATE" 32 '(2 "_NET_WM_STATE_MAXIMIZED_VERT" 0))

;;; color-theme
(color-theme-initialize)
(color-theme-gnome2)

;;; add user site dir
(add-to-list 'load-path "~/.emacs.d/site-lisp/")

;;; set fill-column
(setq-default fill-column 80)
(require 'fill-column-indicator)
(define-globalized-minor-mode global-fci-mode fci-mode (lambda () (fci-mode 1)))
(global-fci-mode 1)

;;; js2-mode
(autoload 'js2-mode "js2" nil t)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))


