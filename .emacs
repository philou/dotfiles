(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(safe-local-variable-values (quote ((encoding . utf-8)))))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "white" :foreground "black" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 82 :width normal :foundry "unknown" :family "DejaVu Sans Mono")))))

;; remove toolbar
(tool-bar-mode -1)

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
(global-set-key [(control :)] 'comment-region)
(global-set-key [(control /)] 'uncomment-region)

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

;; cucumber.el -- Emacs mode for editing plain text user stories
(add-to-list 'load-path "~/.emacs.d/elisp/cucumber.el")
;; optional configurations
;; default language if .feature doesn't have "# language: fi"
;(setq feature-default-language "fi")
;; point to cucumber languages.yml or gherkin i18n.yml to use
;; exactly the same localization your cucumber uses
;(setq feature-default-i18n-file "/path/to/gherkin/gem/i18n.yml")
;; and load feature-mode
(require 'feature-mode)
(add-to-list 'auto-mode-alist '("\.feature$" . feature-mode))

;; rdebug.el -- emacs ruby debugging
(require 'rdebug)

;; associate ruby mode with other ruby extesions
(add-to-list 'load-path "~/.emacs.d/elisp/ruby-electric/")
(add-to-list 'auto-mode-alist '("Rakefile$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\.rake$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\.gemspec$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Gemfile$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Gemfile\.lock$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Guardfile$" . ruby-mode))

(add-hook 'ruby-mode-hook
          (lambda()
            (imenu-add-to-menubar "IMENU")
            (require 'ruby-electric)
            (ruby-electric-mode t)
            ))

(put 'upcase-region 'disabled nil)

(put 'downcase-region 'disabled nil)

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

;; coffee script mode
(setq tab-width 2)
(load "~/.emacs.d/elisp/coffee-mode/coffee-mode.el")


;;;; radiant mode
;;;; updates radiant db and restarts the radiant serveron file save

;; the radiant process
(defvar radiant-process)

(defun radiant-stop()
  "Stops the radiant cms server process"
  (if (boundp 'radiant-process)
      (progn
        (delete-process radiant-process)
        (makunbound 'radiant-process))))

(defun radiant-refresh()
  "Stops the current radiant server, updates the db with local changes, and restarts the server"
  (if (not (boundp 'radiant-process))
      (let ((default-directory "/home/philou/Code/mes-courses.fr/cms/"))
        (call-process "rake" nil "*radiant*" t "fs:to_db")
        (setq radiant-process (start-process "radiant-cms" "*radiant*" "ruby" "script/server")))))

(defun radiant-mode()
  "Restarts the radiant cms server on file save"
  (interactive)
  (progn
    (get-buffer-create "*radiant*")
    (add-hook 'before-save-hook 'radiant-stop t t)
    (add-hook 'after-save-hook 'radiant-refresh t t)))

(defun radiant-mode-exit()
  "Stops radiant cms restart on file save"
  (interactive)
  (progn
    (remove-hook 'before-save-hook 'radiant-stop t t)
    (remove-hook 'after-save-hook 'radiant-refresh t t)
    (radiant-stop)))

(add-to-list 'load-path "~/.emacs.d/elisp/emacs_chrome/servers/")
(when (and (require 'edit-server nil t) (daemonp))
  (edit-server-start))

;; graphviz mod
(add-to-list 'load-path "~/.emacs.d/elisp/graphviz-dot-mode/")
(require 'graphviz-dot-mode)

(add-hook 'graphviz-dot-mode-hook
          (lambda ()
            (add-hook 'after-save-hook 'recompile nil 'make-it-local)))
