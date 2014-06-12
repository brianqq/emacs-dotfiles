(setq debug-on-error t)

(require 'cl)

(add-to-list 'default-frame-alist '(font . "Inconsolata-11"))


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
 '(TeX-command-list (quote (("TeX" "%(PDF)%(tex) %`%S%(PDFout)%(mode)%' %t" TeX-run-TeX nil (plain-tex-mode texinfo-mode ams-tex-mode) :help "Run plain TeX") ("LaTeX" "%`%l%(mode)%' %t" TeX-run-TeX nil (latex-mode doctex-mode) :help "Run LaTeX") ("Makeinfo" "makeinfo %t" TeX-run-compile nil (texinfo-mode) :help "Run Makeinfo with Info output") ("Makeinfo HTML" "makeinfo --html %t" TeX-run-compile nil (texinfo-mode) :help "Run Makeinfo with HTML output") ("AmSTeX" "%(PDF)amstex %`%S%(PDFout)%(mode)%' %t" TeX-run-TeX nil (ams-tex-mode) :help "Run AMSTeX") ("ConTeXt" "texexec --once --texutil %(execopts)%t" TeX-run-TeX nil (context-mode) :help "Run ConTeXt once") ("ConTeXt Full" "texexec %(execopts)%t" TeX-run-TeX nil (context-mode) :help "Run ConTeXt until completion") ("BibTeX" "bibtex %s" TeX-run-BibTeX nil t :help "Run BibTeX") ("Biber" "biber %s" TeX-run-Biber nil t :help "Run Biber") ("View" "%V" TeX-run-discard-or-function t t :help "Run Viewer") ("Print" "%p" TeX-run-command t t :help "Print the file") ("Queue" "%q" TeX-run-background nil t :help "View the printer queue" :visible TeX-queue-command) ("File" "%(o?)dvips %d -o %f " TeX-run-command t t :help "Generate PostScript file") ("Index" "makeindex %s" TeX-run-command nil t :help "Create index file") ("Check" "lacheck %s" TeX-run-compile nil (latex-mode) :help "Check LaTeX file for correctness") ("Spell" "(TeX-ispell-document \"\")" TeX-run-function nil t :help "Spell-check the document") ("Clean" "TeX-clean" TeX-run-function nil t :help "Delete generated intermediate files") ("Clean All" "(TeX-clean t)" TeX-run-function nil t :help "Delete generated intermediate and output files") ("Other" "" TeX-run-command t t :help "Run an arbitrary command") ("latexmk" "latexmk %l -pdf " TeX-run-command nil t))))
 '(fuel-listener-factor-binary "/usr/lib/factor/factor")
 '(fuel-listener-factor-image "/usr/lib/factor/factor.image")
 '(inhibit-startup-screen t)
 '(safe-local-variable-values (quote ((Package . CL-PPCRE) (Base . 10) (Package . CL-USER) (Syntax . COMMON-LISP)))))


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

;;lisp
(require 'slime)
(setq slime-lisp-implementations
      '((sbcl ("sbcl") :coding-system utf-8-unix)
	(sbcl-build ("~/sbcl/run-sbcl.sh") :coding-system utf-8-unix)
	(ccl ("ccl64"))
	(ecl ("ecl"))
	(abcl ("abcl"))))
(slime-setup '(slime-fancy))
(setq common-lisp-hyperspec-root "file:///usr/share/doc/HyperSpec/"
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
(setq org-export-latex-listings 'minted)
(unless (boundp 'org-export-latex-packages-alist)
  (setq org-export-latex-packages-alist nil))
(add-to-list 'org-export-latex-packages-alist '("" "minted"))
(add-hook 'org-mode-hook (lambda () (require 'ob-latex)))
;;;open pdfs with evince
(eval-after-load "org"
  '(progn
     ;; Change .pdf association directly within the alist
     (setcdr (assoc "\\.pdf\\'" org-file-apps) "evince %s")))


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

;color theme
(add-to-list 'load-path "~/.emacs.d/color-theme-6.6.0")
(require 'color-theme)
(color-theme-initialize)
(color-theme-charcoal-black)

;;; haskell
(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)
(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
(add-to-list 'completion-ignored-extensions ".hi")


;;; autocomplete mode
(setq-default ac-sources '(ac-source-abbrev ac-source-dictionary ac-source-words-in-same-mode-buffers))
;;; slime
(add-hook 'slime-mode-hook 'set-up-slime-ac) ;will this break for clj?
(add-hook 'slime-repl-mode-hook 'set-up-slime-ac)
(eval-after-load "auto-complete"
  '(add-to-list 'ac-modes 'slime-repl-mode))
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
