(setq debug-on-error t)

(require 'cl)

(add-to-list 'default-frame-alist '(font . "Inconsolatazi4-11")
	     '(variable-pitch ((t (:family "Inconsolatazi4-11" :slant normal :weight regular :height 98 )))))

;;; hippie expand
(global-set-key "\M- " 'hippie-expand)

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

(ido-mode 1)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes (quote ("146d24de1bb61ddfa64062c29b5ff57065552a7c4019bee5d869e938782dfc2a" default)))
 '(proof-prog-name-ask t))

;;auctex
(setq-default TeX-master nil)
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
  (lisp-setup) (pretty-lambda-mode))


;; ;;lisp
(require 'slime)
(setq slime-lisp-implementations
      '((sbcl ("sbcl") :coding-system utf-8-unix)
	(sbcl-build ("~/sbcl/run-sbcl.sh") :coding-system utf-8-unix)
	(ccl ("ccl64"))
	(ecl ("ecl"))
	(clisp ("clisp"))
	(abcl ("abcl"))))
(slime-setup '(slime-fancy))
(setq ;; common-lisp-hyperspec-root "file:///usr/share/doc/HyperSpec/"
      slime-complete-symbol-function 'slime-fuzzy-complete-symbol)
(add-hook 'slime-mode-hook #'standard-lisp-setup)
(add-hook 'slime-repl-mode-hook #'lisp-setup)
(add-hook 'slime-repl-mode-hook #'override-slime-repl-bindings-with-paredit)

(add-hook 'emacs-lisp-mode-hook 'standard-lisp-setup)

;;Org Mode
(require 'org-install)
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(setq org-log-done t)
(setq org-catch-invisible-edits 'smart)
(setq org-directory "~/Dropbox/todo")
(setq org-mobile-inbox-for-pull "~/Dropbox/todo/flagged.org")
(setq org-mobile-directory "~/Dropbox/MobileOrg")
(setq org-agenda-files '("~/Dropbox/todo/syllabi.org" "~/Dropbox/todo/tasklist.org"))
(setq org-default-notes-file (concat org-directory "/notes.org"))
(define-key global-map "\C-cc" 'org-capture)
(setq org-src-fontify-natively t)
;;; org latex
(unless (boundp 'org-export-latex-classes)
  (setq org-export-latex-classes nil))
(add-to-list 'org-export-latex-classes
             '("article"
               "\\documentclass{article}"
               ("\\section{%s}" . "\\section*{%s}")
               ("\\subsection{%s}" . "\\subsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
               ("\\paragraph{%s}" . "\\paragraph*{%s}")
               ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))
(setq org-todo-keywords
      '((sequence "TODO" "STARTED" "|" "DONE")
	(sequence "|" "CANCELLED")))
(setq org-todo-keyword-faces
      '(("STARTED" . "yellow")
	("CANCELED" . (:foreground "blue" :weight bold))))

(unless (boundp 'org-export-latex-packages-alist)
  (setq org-export-latex-packages-alist nil))
(add-hook 'org-mode-hook (lambda ()
			   (require 'ob-latex)
			   (require 'ox-latex)))
;;minted
(add-to-list 'org-export-latex-packages-alist '("" "minted"))
(setq org-export-latex-listings 'minted)
(setq org-latex-minted-options
      '(("frame" "lines")
	("linenos=true")))
;;;open pdfs with evince
(eval-after-load "org"
  '(progn
     ;; Change .pdf association directly within the alist
     (setcdr (assoc "\\.pdf\\'" org-file-apps) "evince %s")))

(put 'downcase-region 'disabled nil)

;;;multiple cursors
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)
(global-set-key (kbd "s-SPC") 'set-rectangular-region-anchor)
(put 'narrow-to-region 'disabled nil)

(put 'dired-find-alternate-file 'disabled nil)

(global-set-key (kbd "C-c C-w") 'fixup-whitespace)
(eval-after-load "dired-aux"
  '(add-to-list 'dired-compress-file-suffixes
		'("\\.zip\\'" ".zip" "unzip")))

;;; haskell
(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)
(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
(add-to-list 'completion-ignored-extensions ".hi")


;;; autocomplete mode
(setq-default ac-sources '(ac-source-abbrev ac-source-dictionary ac-source-words-in-same-mode-buffers))
;;; slime/autocomplete 
(add-hook 'slime-mode-hook 'auto-complete-mode)
;(add-hook 'slime-mode-hook 'set-up-slime-ac)
;(add-hook 'slime-repl-mode-hook 'set-up-slime-ac)


(eval-after-load "auto-complete"
  '(progn
     (require 'auto-complete-config)
     (ac-config-default)
     (ac-set-trigger-key "TAB")
     (ac-set-trigger-key "<tab>")
     (add-to-list 'ac-modes 'slime-repl-mode)))
;;; clang
(defun my-ac-cc-mode-setup ()
  (auto-complete-mode 1)
  (setq ac-sources (cons 'ac-source-clang ac-sources)))
(eval-after-load "auto-complete"
  '(add-hook 'c++-mode-hook 'my-ac-cc-mode-setup))

(add-hook 'scheme-mode-hook 'standard-lisp-setup)
(add-hook 'geiser-repl-mode-hook 'lisp-setup)

;;; info mode
(defun info-mode ()
  (interactive)
  (let ((file-name (buffer-file-name)))
    (kill-buffer (current-buffer))
    (info file-name)))
(add-to-list 'auto-mode-alist '("\\.info\\'" . info-mode))

;;; jabber otr
;; (load-file "~/emacs-jabber-otr/jabber-otr.el")

(defun my-move-key (keymap-from keymap-to key)
  "Moves key binding from one keymap to another, deleting from the old location. "
  (define-key keymap-to key (lookup-key keymap-from key))
  (define-key keymap-from key nil))

;;; evil-mode
(eval-after-load "evil"
  '(progn
     (define-key evil-motion-state-map "h" 'evil-next-line)   ;j 
     (define-key evil-motion-state-map "t" 'evil-previous-line) ;k 
     (define-key evil-motion-state-map "n" 'evil-forward-char)  ;l
     (define-key evil-motion-state-map "d" 'evil-backward-char) ;h
     (define-key evil-normal-state-map "d" nil) ;d was bound to delete mode
     (define-key evil-normal-state-map "k" 'evil-delete)
     (my-move-key evil-motion-state-map evil-normal-state-map (kbd "RET"))
     (my-move-key evil-motion-state-map evil-normal-state-map " ")
     (my-move-key evil-motion-state-map evil-normal-state-map (kbd "<tab>"))
     (evil-mode 1)))

(eval-after-load "evil-paredit"
  '(progn
     (define-key evil-paredit-mode-map "d" nil)))

(defun after-all-loads ()
  (powerline-evil-center-color-theme)
  (load-theme 'zenburn t)
  (global-auto-complete-mode 1))


(add-hook 'after-init-hook 'after-all-loads)

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(rainbow-delimiters-depth-1-face ((t (:foreground "#906083"))))
 '(rainbow-delimiters-depth-2-face ((t (:foreground "#805030"))))
 '(rainbow-delimiters-depth-3-face ((t (:foreground "#808040"))))
 '(rainbow-delimiters-depth-4-face ((t (:foreground "#427023"))))
 '(rainbow-delimiters-depth-5-face ((t (:foreground "#4050A0"))))
 '(rainbow-delimiters-depth-6-face ((t (:foreground "#A05073"))))
 '(rainbow-delimiters-depth-7-face ((t (:foreground "#707050")))))


(load-file "/usr/share/emacs/site-lisp/ProofGeneral/generic/proof-site.el")

;;; w3m
(setq browse-url-browser-function 'w3m-goto-url)
(setq w3m-user-agent "Mozilla/5.0 (Linux; U; Android 2.3.3")
(autoload 'w3m-browse-url "w3m" "WWW browser to show url" t)
(global-set-key "\C-xm" 'w3m-goto-url)
