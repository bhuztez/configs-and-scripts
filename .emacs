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

(setq tramp-default-method "ssh")

;;; add user site dir
(add-to-list 'load-path "~/.emacs.d/site-lisp/")

;;; set fill-column
;;; (setq-default fill-column 80)
(require 'fill-column-indicator)
(define-globalized-minor-mode global-fci-mode fci-mode (lambda () (fci-mode 1)))
(global-fci-mode 1)

;;; js2-mode
(autoload 'js2-mode "js2" nil t)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))

(require 'multi-term)
(setq multi-term-program "/bin/bash")

;;; ibus integration
(require 'ibus)
(defconst ibus-default-engine "xkb:layout:default:#0")

(defun ibus-set-keymap-parent ()
  (if (not (equal ibus-imcontext-status ibus-default-engine))
      (set-keymap-parent ibus-mode-map
			 (cond
			  ((or (not (eq window-system 'x))
			       ibus-mode-map-prev-disabled)
			   nil)
			  (ibus-imcontext-status
			   ibus-mode-common-map)
			  (t
			   ibus-mode-minimum-map)))
    )
  )

(defun ibus-toggle-engine (&optional engine-name)
  (interactive)
  (when (and (interactive-p)
	     (null ibus-current-buffer))
    (ibus-check-current-buffer))
  (ibus-disable-keymap)
  (if (equal ibus-imcontext-status engine-name)
      (ibus-enable ibus-default-engine)
    (ibus-enable engine-name)
    (ibus-enable-keymap)))

(ibus-define-common-key ?\C-\s nil)

(global-set-key (kbd "C-\\") (lambda () (interactive) (ibus-toggle-engine "pinyin")))
