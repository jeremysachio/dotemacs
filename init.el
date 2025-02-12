;;; Minimum version

(when (< emacs-major-version 29)
  (error "This configuration requires Emacs 29 or later"))

;;; Custom file

(setopt custom-file (locate-user-emacs-file "custom.el"))
(load custom-file :no-error-if-file-is-missing)

;;; Package manager

(require 'package)
(package-initialize)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))

;;; Installation warnings

(add-to-list 'display-buffer-alist
             '("\\`\\*\\(Warnings\\|Compile-Log\\)\\*\\'"
               (display-buffer-no-window)
               (allow-no-window . t)))

;;; Prot's C-g

(defun prot/keyboard-quit-dwim ()
  "Do-What-I-Mean behaviour for a general `keyboard-quit'.

  The generic `keyboard-quit' does not do the expected thing when
  the minibuffer is open.  Whereas we want it to close the
  minibuffer, even without explicitly focusing it.

  The DWIM behaviour of this command is as follows:

  - When the region is active, disable it.
  - When a minibuffer is open, but not focused, close the minibuffer.
  - When the Completions buffer is selected, close it.
  - In every other case use the regular `keyboard-quit'."
  (interactive)
  (cond
   ((region-active-p)
    (keyboard-quit))
   ((derived-mode-p 'completion-list-mode)
    (delete-completion-window))
   ((> (minibuffer-depth) 0)
    (abort-recursive-edit))
   (t
    (keyboard-quit))))

(define-key global-map (kbd "C-g") #'prot/keyboard-quit-dwim)

;;; Built-in modes

(column-number-mode)
(context-menu-mode)
(delete-selection-mode)
(pixel-scroll-precision-mode)
(repeat-mode)
(savehist-mode)

;;; User options

(setopt backup-directory-alist '(("." . "~/.emacs_backups"))
        frame-resize-pixelwise t
	indent-tabs-mode nil
  	inhibit-splash-screen t
	mouse-wheel-flip-direction t
	mouse-wheel-tilt-scroll t
  	next-line-add-newlines t
  	sentence-end-double-space nil
  	truncate-lines t
  	visible-bell t)

;;; Packages

(use-package apheleia
  :ensure t
  :hook python-ts-mode
  :config
  (add-to-list 'apheleia-mode-alist
	       '(python-ts-mode . (ruff ruff-isort))))

(use-package avy
  :ensure t
  :bind (("C-c a c" . avy-goto-char)
         ("C-c a e" . avy-goto-end-of-line)
         ("C-c a f" . avy-goto-word-1) ; [f]irst letter of word
         ("C-c a l" . avy-goto-line)
         ("C-c a p" . avy-goto-char-2) ; [p]air of chars
         ("C-c a t" . avy-goto-char-timer)
         ("C-c a w" . avy-goto-word-0)
         ("C-c a d l" . avy-copy-line) ; [d]uplicate
         ("C-c a d r" . avy-copy-region)
         ("C-c a k l" . avy-kill-whole-line)
         ("C-c a k r" . avy-kill-region)
         ("C-c a m l" . avy-move-line)
         ("C-c a m r" . avy-move-region)
         ("C-c a s l" . avy-kill-ring-save-whole-line)
         ("C-c a s r" . avy-kill-ring-save-region)))

(use-package corfu
  :ensure t
  :hook python-ts-mode)

(use-package magit
  :ensure t)

(use-package marginalia
  :ensure t
  :hook after-init)

(use-package orderless
  :ensure t
  :config
  (setopt completion-styles '(orderless basic)
  	  completion-category-defaults nil
  	  completion-category-overrides nil))

(use-package org
  :bind (("C-c o l" . org-store-link)
	 ("C-c o a" . org-agenda)
	 ("C-c o c" . org-capture))
  :hook (org-mode . auto-fill-mode)
  :config
  (setopt org-ctrl-k-protect-subtree t
  	  org-hide-block-startup t
  	  org-insert-heading-respect-content t
	  org-log-into-drawer t
  	  org-M-RET-may-split-line '((default . nil))
  	  org-special-ctrl-a/e t
  	  org-special-ctrl-k t
  	  org-startup-folded 'content
  	  org-tags-column 0
  	  org-todo-keywords '((sequence "TODO(t)"
  					"WAIT(w!)"
  					"|"
  					"NOPE(n!)"
  					"DONE(d!)"))))

(use-package spacious-padding
  :ensure t
  :hook after-init)
