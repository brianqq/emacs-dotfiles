(set-face-attribute 'default nil 
		    :font "Inconsolata" :height 95)

(global-font-lock-mode 1) 
(show-paren-mode 1)

(defalias 'yes-or-no-p 'y-or-n-p)

(require 'package) 
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/") t)

(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))

(defun toggle-fullscreen ()
  "Toggle full screen on X11"
  (interactive)
  (when (eq window-system 'x)
    (set-frame-parameter
     nil 'fullscreen
     (when (not (frame-parameter nil 'fullscreen)) 'fullboth))))
(global-set-key [f11] 'toggle-fullscreen)


(require 'cl)

;color theme
(add-to-list 'load-path "~/.emacs.d/color-theme-6.6.0")
(require 'color-theme)
(color-theme-initialize)
(color-theme-charcoal-black)

;;acutex
(load "auctex.el" nil t t)
(load "preview-latex.el" nil t t)
(setq TeX-auto-save t)
(setq TeX-parse-self t)

;;lisp hook
(defun lisp-setup ()
  (paredit-mode 1)
  (rainbow-delimiters-mode 1))

(defun standard-lisp-setup ()
  (lisp-setup) (pretty-lambda-mode))

(add-hook 'clojure-mode-hook #'lisp-setup)
;;; all code in this function lifted from the clojure-mode function
;;; from clojure-mode.el

;; (defun clojure-font-lock-setup ()
;;   (interactive)
;;   (set (make-local-variable 'lisp-indent-function)
;;        'clojure-indent-function)
;;   (set (make-local-variable 'lisp-doc-string-elt-property)
;;        'clojure-doc-string-elt)
;;   (set (make-local-variable 'font-lock-multiline) t)
;;   (add-to-list 'font-lock-extend-region-functions
;;                'clojure-font-lock-extend-region-def t)
;;   (when clojure-mode-font-lock-comment-sexp
;;     (add-to-list 'font-lock-extend-region-functions
;;                  'clojure-font-lock-extend-region-comment t)
;;     (make-local-variable 'clojure-font-lock-keywords)
;;     (add-to-list 'clojure-font-lock-keywords
;;                  'clojure-font-lock-mark-comment t)
;;     (set (make-local-variable 'open-paren-in-column-0-is-defun-start) nil))
;;   (setq font-lock-defaults
;;         '(clojure-font-lock-keywords    ; keywords
;;           nil nil
;;           (("+-*/.<>=!?$%_&~^:@" . "w")) ; syntax alist
;;           nil
;;           (font-lock-mark-block-function . mark-defun)
;;           (font-lock-syntactic-face-function
;;            . lisp-font-lock-syntactic-face-function))))


;;lisp 
(defun slimify ()
  (interactive)
  (require 'slime)
  (setq slime-lisp-implementations
	'((sbcl ("sbcl") :coding-system utf-8-unix)
	  (ccl ("ccl64"))
	  (ecl ("ecl"))))
  (slime-setup '(slime-fancy))
  (add-hook 'slime-mode-hook #'standard-lisp-setup)
  (add-hook 'slime-repl-mode-hook #'lisp-setup))

(add-hook 'emacs-lisp-mode-hook #'standard-lisp-setup)


;;maxima
 (add-to-list 'load-path "/usr/share/maxima/5.27.0/emacs/")
 (autoload 'maxima-mode "maxima" "Maxima mode" t)
 (autoload 'imaxima "imaxima" "Frontend for maxima with Image support" t)
 (autoload 'maxima "maxima" "Maxima interaction" t)
 (autoload 'imath-mode "imath" "Imath mode for math formula input" t)
 (setq imaxima-use-maxima-mode-flag t)

;;Org Mode
(require 'org-install)
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(setq org-log-done t)

;;chrome editing
(add-to-list 'load-path "~/.emacs.d")
(require 'edit-server)
(edit-server-start)

;(require 'ibus)
;(add-hook 'after-init-hook 'ibus-mode-on)

;;Jabber
(setq jabber-account-list
      '(("brianlevy95@chat.facebook.com"
	 (:network-server . "chat.facebook.com")
	 (:connection-type . network))
	("brianlevy95@gmail.com"
	 (:network-server . "talk.google.com")
	 (:connection-type . ssl))))



(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(inhibit-startup-screen t)
 '(safe-local-variable-values (quote ((Package . CL-PPCRE) (Base . 10) (Package . CL-USER) (Syntax . COMMON-LISP)))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

