;; Install favourite packages
(require 'package)
(package-initialize)

(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/") t)

(unless package-archive-contents
  (package-refresh-contents))

;; General settings
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (dockerfile-mode yaml-mode markdown-mode ruby-electric graphviz-dot-mode feature-mode edit-server coffee-mode)))
 '(safe-local-variable-values (quote ((encoding . utf-8)))))

;; install packages
(package-install-selected-packages)

;; remove toolbar
(tool-bar-mode -1)

;; editing defaults
(setq tab-width 2)
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)

;; rebinding hippie-expand
(global-unset-key [M-/])
(define-key global-map (read-kbd-macro "M-RET") 'hippie-expand)
(require 'completion)

;; Confirmation before quit
(defun secure-kill-emacs(confirm)
        (interactive "Are you really sure you want to kill emacs now ? (y or n)")
        (if (string-equal "y" confirm) (command-execute 'save-buffers-kill-emacs)))
(global-set-key "\C-x\C-c" 'secure-kill-emacs)

;; Type 'y' instead of 'yes'
(fset 'yes-or-no-p 'y-or-n-p)

;; automaticaly revert buffers if changed on disk
(global-auto-revert-mode)

;; C-M-\ is inaccessible on windows ...
(global-set-key [(control c) (control f)] 'indent-region)

;; comment/uncomment region
(global-set-key [(control /)] 'comment-region)
(global-set-key [(control :)] 'uncomment-region)

;; text defaults
(add-hook 'before-save-hook 'delete-trailing-whitespace)
(add-hook 'before-save-hook 'copyright-update)
(setq-default indent-tabs-mode nil)

;; windows size
(global-set-key [(control +)]    'enlarge-window)
(global-set-key [(control -)]    'shrink-window)

;; iswitch-mode
(iswitchb-mode)
(defun iswitchb-local-keys ()
  (mapc (lambda (K)
          (let* ((key (car K)) (fun (cdr K)))
            (define-key iswitchb-mode-map (edmacro-parse-keys key) fun)))
        '(("<right>" . iswitchb-next-match)
          ("<left>"  . iswitchb-prev-match)
          ("<up>"    . ignore             )
          ("<down>"  . ignore             ))))
(add-hook 'iswitchb-define-mode-map-hook 'iswitchb-local-keys)

;; javascript 2 mode
(autoload 'js2-mode "js2" nil t)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))
(setq js-indent-level 2)

;; rdebug.el -- emacs ruby debugging
;;(require 'rdebug)

;; associate ruby mode with other ruby extesions
(add-to-list 'auto-mode-alist '("Rakefile$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\.rake$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\.gemspec$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Gemfile$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Gemfile\.lock$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Guardfile$" . ruby-mode))

(add-hook 'ruby-mode-hook
          (lambda()
            (imenu-add-to-menubar "IMENU")
            (ruby-electric-mode t)
            ))


;; nXhtml mode
(load "~/.emacs.d/elisp/nxhtml/autostart.el")
(setq
 nxhtml-global-minor-mode t
 mumamo-chunk-coloring 'submode-colored
 nxhtml-skip-welcome t
 indent-region-mode t
 rng-nxml-auto-validate-flag nil
 nxml-degraded t)
(add-to-list 'auto-mode-alist '("\.html\.erb$" . eruby-nxhtml-mumamo-mode))

;; Edit from chrome
(when (daemonp)
  (edit-server-start))

;; graphviz mod
(add-to-list 'auto-mode-alist '("\.gv$" . graphviz-dot-mode))
(add-to-list 'auto-mode-alist '("\.dot$" . graphviz-dot-mode))

(add-hook 'graphviz-dot-mode-hook
          (lambda ()
            (add-hook 'after-save-hook 'recompile nil 'make-it-local)))

;; markdown mode
(setq markdown-command "docker run -i -v ${PWD}:/work/ pbourgau/docker-grip-export grip --export -")
