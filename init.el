;;; init.el --- My emacs configuration -*- lexical-binding: t; -*-

;; Copyright (C) 2021 eggplants

;; Author: haruna <eggplants@github.com>
;; Created: 3 April 2021
;; License: GPL-3.0

;; This file is NOT part of GNU Emacs.

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; This is my emacs configuration

;;; Code:

(require 'package)

;;
;; add package manager
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/") t)
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t)
(add-to-list 'package-archives '("ELPA" . "http://tromey.com/elpa/") t)

(package-initialize)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (rainbow-delimiters rainbow-mode company-jedi slime-company ac-slime fuzzy auto-complete-rst smooth-scroll powerline hlinum blank-mode lsp-ui jedi slime lsp-mode monokai-theme atom-one-dark-theme changelog-url flycheck-package flycheck package-lint helm))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; color theme
;; (load-theme 'atom-one-dark t)
(load-theme 'monokai t)

;; line number
(require 'hlinum) ;; highlight current line number
(global-nlinum-mode t)
(setq nlinum-format "%05d│ ")

;; off menu bar
(menu-bar-mode 0)

;; highlight paren
(show-paren-mode 1)

;; terbell off
(setq ring-bell-function 'ignore)

;;;;;;;;;;;;;;;;;;;;
;; package config ;;
;;;;;;;;;;;;;;;;;;;;
;;
;; use-package
(eval-when-compile (require 'use-package))
;; (require 'diminish)    ;; if you use :diminish
;; (require 'bind-key)    ;; if you use any :bind variant
(setq use-package-verbose t)
(setq use-package-minimum-reported-time 0.001)

;;
;; auto-complete
;; (require 'auto-complete)
;; (require 'auto-complete-config)
;; (require 'fuzzy) ;; fuzzy search (heaby)
;; (setq ac-use-fuzzy t)
;; (global-auto-complete-mode t)
;; (ac-config-default)
;; (setq ac-delay 0)
;; (setq ac-auto-show-menu 0.05)
;; (ac-set-trigger-key "TAB")
;; (setq ac-use-menu-map t)
;; (setq ac-menu-height 25)
;; (setq ac-auto-start 2)
;; (setq ac-ignore-case t)
;; (define-key ac-completing-map (kbd "<tab>") 'ac-complete)

;;
;; rainbow-mode, rainbow-delimiters
(require 'rainbow-delimiters)
(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)

;; 括弧の色を強調する設定
(require 'cl-lib)
(require 'color)
(defun rainbow-delimiters-using-stronger-colors ()
  (interactive)
  (cl-loop
   for index from 1 to rainbow-delimiters-max-face-count
   do
   (let ((face (intern (format "rainbow-delimiters-depth-%d-face" index))))
     (cl-callf color-saturate-name (face-foreground face) 30))))

(add-hook 'emacs-startup-hook 'rainbow-delimiters-using-stronger-colors)
(add-hook 'css-mode-hook 'rainbow-delimiters-mode)
(add-hook 'html-mode-hook 'rainbow-delimiters-mode)
(add-hook 'emacs-lisp-mode-hook 'rainbow-delimiters-mode)
(add-hook 'lisp-mode-hook 'rainbow-delimiters-mode)

;;
;; powerline
(require 'powerline)
;; (powerline-nano-theme)
(powerline-default-theme)

;;
;; slime
;; (load (expand-file-name "~/.roswell/helper.el"))
(use-package slime
  :if (file-exists-p "~/.roswell/helper.el")
  :ensure slime-company
  :init (load "~/.roswell/helper.el")
  :custom (inferior-lisp-program "ros -Q run")
  :config (slime-setup '(slime-fancy slime-company)))

;;
;; flycheck, flycheck-package
(eval-after-load 'flycheck '(flycheck-package-setup))
(add-hook 'after-init-hook #'global-flycheck-mode)

;;
;; solargraph - ruby lsp
(require 'lsp-mode)
(require 'lsp-ui)
(add-hook 'ruby-mode-hook #'lsp-mode-enable)

;;
;; jedi - python lsp
;; (require 'jedi)
;; (add-hook 'python-mode-hook 'jedi:setup)
;; (setq jedi:complete-on-dot t)
(require 'jedi-core)
(setq jedi:complete-on-dot t)
(setq jedi:use-shortcuts t)
(add-hook 'python-mode-hook 'jedi:setup)
(add-to-list 'company-backends 'company-jedi)

;;
;; common lisp lsp
;;;; Common Lisp
;; (setq inferior-lisp-program "ccl64")
;; (setq inferior-lisp-program "clisp")
;; (add-hook 'lisp-mode-hook
;;           (lambda ()
;;             ;; (slime-mode t)
;;             (define-key lisp-mode-map (kbd "C-c C-s") 'slime)
;;             (add-to-list 'ac-sources 'ac-source-slime)))
;; (add-hook 'comint-mode-hook
;;           (lambda ()
;;             ;; (slime-mode t)
;;            (auto-complete-mode t)))

;;
;; helm
(require 'helm)
(require 'helm-config)
 
(global-set-key (kbd "C-c h") 'helm-command-prefix)
(global-unset-key (kbd "C-x c"))
 
(define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) ;; </tab>
(define-key helm-map (kbd "C-i") 'helm-execute-persistent-action)
(define-key helm-map (kbd "C-z")  'helm-select-action)
 
(when (executable-find "curl")
  (setq helm-google-suggest-use-curl-p t))
 
(setq helm-split-window-in-side-p           t
      helm-move-to-line-cycle-in-source     t
      helm-ff-search-library-in-sexp        t
      helm-scroll-amount                    8
      helm-ff-file-name-history-use-recentf t
      helm-echo-input-in-header-line t)
 
(defun spacemacs//helm-hide-minibuffer-maybe ()
  "Hide minibuffer in Helm session if we use the header line as input field."
  (when (with-helm-buffer helm-echo-input-in-header-line)
    (let ((ov (make-overlay (point-min) (point-max) nil nil t)))
      (overlay-put ov 'window (selected-window))
      (overlay-put ov 'face
                   (let ((bg-color (face-background 'default nil)))
                     `(:background ,bg-color :foreground ,bg-color)))
      (setq-local cursor-type nil))))
 
 
(add-hook 'helm-minibuffer-set-up-hook
          'spacemacs//helm-hide-minibuffer-maybe)
 
(setq helm-autoresize-max-height 0)
(setq helm-autoresize-min-height 20)
(helm-autoresize-mode 1)
 
(helm-mode 1)
 
;; helm: enable helm-M-x
(global-set-key (kbd "M-x") 'helm-M-x)
 
;; helm: fuzzy search
(setq helm-M-x-fuzzy-match t)
 
;; helm: bind persistent action
(define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) ;; </tab>
 
;; helm: bind make TAB works in terminal
(define-key helm-map (kbd "C-i") 'helm-execute-persistent-action)
 
;; helm: bind list actions
(define-key helm-map (kbd "C-z")  'helm-select-action)
 
;; helm: resize buffer size depending on num of bufs
(helm-autoresize-mode t)
 
;; helm: show kill ring
(global-set-key (kbd "M-y") 'helm-show-kill-ring)
 
;; helm: enable to handle other source by helm
(global-set-key (kbd "C-x b") 'helm-mini)
(setq helm-buffers-fuzzy-matching t
      helm-recentf-fuzzy-match    t)
 
;; helm: file fuzzy search
(global-set-key (kbd "C-x C-f") 'helm-find-files)
 
;; helm: Semantic & Imenu fuzzy search
(setq helm-semantic-fuzzy-match t
      helm-imenu-fuzzy-match    t)
 
;; helm: マニュアルページに素早く飛ぶ。ミニバッファにpatternを入力可能、カーソルの指すシンボルをそのまま検索可能
(add-to-list 'helm-sources-using-default-as-input 'helm-source-man-pages)
 
;; helm: helm-locate fuzzy search
(setq helm-locate-fuzzy-match t)
 
;; helm: bind helm-occur to C-c-h-o
(global-set-key (kbd "C-c h o") 'helm-occur)
 
;; helm: apropos fuzzy search
(setq helm-apropos-fuzzy-match t)
 
;; helm: funcs in Emacs Lisp fuzzy search
(setq helm-lisp-fuzzy-completion t)
 
;; helm: bind helm-all-mark-rings
;; (global-set-key (kbd "C-h SPC") 'helm-all-mark-rings)
 
;; helm: enable to search google
 (setq helm-surfraw-default-browser-function 'browse-url-generic
       browse-url-generic-program "google-chrome")
 
;; helm: enable to show Google suggestions
(global-set-key (kbd "C-c h g") 'helm-google-suggest)

(provide 'init)
;;; init.el ends here
