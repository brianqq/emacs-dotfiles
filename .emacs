(setq debug-on-error t)

(require 'cl)

(add-to-list 'default-frame-alist '(font . "Inconsolata-10"))

(global-font-lock-mode 1) 
(show-paren-mode 1)

(setq browse-url-browser-function 'browse-url-generic
      browse-url-generic-program "conkeror")

(defalias 'yes-or-no-p 'y-or-n-p)

(require 'package) 
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/") t)
(add-to-list 'package-archives '("MELPA" . "http://melpa.milkbox.net/packages/") t)

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

(setq initial-scratch-message nil)

(ido-mode)



;color theme
(add-to-list 'load-path "~/.emacs.d/color-theme-6.6.0")
(require 'color-theme)
(color-theme-initialize)
(color-theme-charcoal-black)

;;auctex
(setq TeX-auto-save t)
(setq TeX-parse-self t)

;;lisp hook
(defun lisp-setup ()
  (paredit-mode 1)
  (rainbow-delimiters-mode 1))

(defun override-slime-repl-bindings-with-paredit ()
  (define-key slime-repl-mode-map
    (read-kbd-macro paredit-backward-delete-key) nil))

(defun standard-lisp-setup ()
  (lisp-setup) (pretty-lambda-mode) (paredit-mode 1))

(add-hook 'clojure-mode-hook #'lisp-setup)

(defun cljify ()
  (interactive)
  (add-hook 'slime-repl-mode-hook
          (defun clojure-mode-slime-font-lock ()
            (require 'clojure-mode)
	    (lisp-setup)
            (let (font-lock-mode)
              (clojure-mode-font-lock-setup)))))

;;lisp
(defun slimify ()
  (interactive)
  (require 'slime)
  (setq slime-lisp-implementations
	'((sbcl ("sbcl") :coding-system utf-8-unix)
	  (ccl ("ccl64"))
	  (ecl ("ecl"))
	  (abcl ("abcl"))))
  (slime-setup '(slime-fancy))
  (setq common-lisp-hyperspec-root "file:///usr/share/doc/HyperSpec/"
	slime-complete-symbol-function 'slime-fuzzy-complete-symbol)
  (add-hook 'slime-mode-hook #'standard-lisp-setup)
  (add-hook 'slime-repl-mode-hook #'lisp-setup)
  (add-hook 'slime-repl-mode-hook #'override-slime-repl-bindings-with-paredit))

(add-hook 'emacs-lisp-mode-hook 'standard-lisp-setup)


;maxima
(add-to-list 'load-path "/usr/share/maxima/5.28.0/emacs/")
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


;;Twitter
(add-to-list 'load-path "~/.emacs.d/twittering-mode")
(require 'twittering-mode)

;;Gnus
(setq gnus-select-method '(nnimap "gmail"
				  (nnimap-address "imap.gmail.com")
				  (nnimap-server-port 993)
				  (nnimap-stream ssl)))
(setq message-send-mail-function 'smtpmail-send-it
      smtpmail-starttls-credentials '(("smtp.gmail.com" 587 nil nil))
      smtpmail-auth-credentials '(("smtp.gmail.com" 587 "brianlevy95@gmail.com" nil))
      smtpmail-default-smtp-server "smtp.gmail.com"
      smtpmail-smtp-server "smtp.gmail.com"
      smtpmail-smtp-service 587)

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

(put 'downcase-region 'disabled nil)

;;auto-complete
(add-to-list 'load-path "~/.emacs.d/elpa/popup-0.5")
(add-to-list 'load-path "~/.emacs.d/elpa/auto-complete-1.4")
(require 'auto-complete)
(global-auto-complete-mode t)
(define-key ac-complete-mode-map "\C-n" 'ac-next)
(define-key ac-complete-mode-map "\C-p" 'ac-previous)
(define-key ac-complete-mode-map "\t" 'ac-complete)
(define-key ac-complete-mode-map "\r" nil)
(put 'dired-find-alternate-file 'disabled nil)


;;emacs-eclim
;; this is for eclipse interraction i broke it somehow w/e 
;(require 'eclimd)
;(global-eclim-mode)
;(setq help-at-pt-display-when-idle t)
;(setq help-at-pt-timer-delay 0.1)
;(help-at-pt-set-timer)
;; regular auto-complete initialization
;; add the emacs-eclim source
;(require 'ac-emacs-eclim-source)
;(ac-emacs-eclim-config)

;;geiser
(add-hook 'scheme-mode-hook 'standard-lisp-setup)
(add-hook 'geiser-repl-mode-hook 'lisp-setup)

;;powerline
(add-hook 'before-make-frame-hook 'powerline-center-theme)

;;haskell ass shit
(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)

;; hslint on the command line only likes this indentation mode;
;; alternatives commented out below.
(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)
;;(add-hook 'haskell-mode-hook 'turn-on-haskell-indent)
;;(add-hook 'haskell-mode-hook 'turn-on-haskell-simple-indent)

;; Ignore compiled Haskell files in filename completions
(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)

;; hslint on the command line only likes this indentation mode;
;; alternatives commented out below.
(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)
;;(add-hook 'haskell-mode-hook 'turn-on-haskell-indent)
;;(add-hook 'haskell-mode-hook 'turn-on-haskell-simple-indent)

;; Ignore compiled Haskell files in filename completions
(add-to-list 'completion-ignored-extensions ".hi")

(add-to-list 'after-init-hook (lambda () (require 'switch-window)))
