;; packages
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("org" . "http://orgmode.org/elpa/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")
                         ("melpa-stable" . "http://melpa-stable.milkbox.net/packages/")
                         ("melpa" . "http://melpa.milkbox.net/packages/")))
(package-initialize)

(defun require-package (package)
  (setq-default highlight-tabs t)
  "Install given PACKAGE."
  (unless (package-installed-p package)
    (unless (assoc package package-archive-contents)
      (package-refresh-contents))
    (package-install package)))

;; Evil mode
(require 'evil)
(turn-on-evil-mode)
(evil-space-default-setup)

;; Force evil mode on buffer open
(defun force-evil-mode-on (_)
  (turn-on-evil-mode))

(add-hook 'after-load-functions 'force-evil-mode-on)

;; evil-rebellion
(add-to-list 'load-path "~/.emacs.d/bundle/evil-rebellion/")
(require 'magit)
(require 'evil-magit-rebellion)

;; color theme
(require 'color-theme)
(color-theme-molokai)
(color-theme-approximate-on)

;; evil tabs
(add-to-list 'load-path "~/.emacs.d/bundle/evil-tabs/")
(require 'evil-tabs)
(global-evil-tabs-mode t)

;; projectile
(require 'projectile)
(projectile-global-mode)

;; powerline for evil
(require 'powerline)
(powerline-evil-vim-color-theme)
(display-time-mode t)

;; helm
(require 'helm-config)
(require 'helm-misc)
(require 'helm-projectile)
(require 'helm-locate)
(require 'helm-ag)

(setq helm-quick-update t)
(setq helm-bookmark-show-location t)
(setq helm-buffers-fuzzy-matching t)

(global-set-key (kbd "M-x") 'helm-M-x)

(define-key evil-normal-state-map " " 'helm-projectile)

;; proper code stuff
(setq-default tab-width 4 indent-tabs-mode nil)
(define-key global-map (kbd "RET") 'newline-and-indent)
(show-paren-mode t)
(setq make-backup-files nil)

;; RSpec compile
;; Find root directory by searching for Gemfile
(defun* get-closest-gemfile-root (&optional (file "Gemfile"))
  (let ((root (expand-file-name "/")))
    (loop
     for d = default-directory then (expand-file-name ".." d)
     if (file-exists-p (expand-file-name file d))
     return d
     if (equal d root)
     return nil)))

(defun find-spec-from-file ()
  (interactive)
  (save-excursion
    (find-file
     (replace-regexp-in-string
      "\n$" ""
      (shell-command-to-string
       (concat "find "
               (get-closest-gemfile-root)
               " -type f -name "
               (concat (substring (car (last (split-string (buffer-file-name) "/"))) 0 -3)
                       "_spec.rb")))))))

(defun rspec-format-string (&optional line-p)
  (concat "cd %s && "
          "bin/rspec --format documentation %s"
          (when line-p " -l %s")))

(defun rspec-compile-file ()
  (interactive)
  (compile (format (rspec-format-string)
                   (get-closest-gemfile-root)
                   (file-relative-name (buffer-file-name) (get-closest-gemfile-root))
                   ) t))

(defun rspec-compile-on-line ()
  (interactive)
  (compile (format (rspec-format-string t)
                   (get-closest-gemfile-root)
                   (file-relative-name (buffer-file-name) (get-closest-gemfile-root))
                   (line-number-at-pos)
                   ) t))

;; haskell-mode
;;(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indent)
;;(add-hook 'haskell-mode-hook 'turn-on-haskell-simple-indent)

;; emacs server
(server-start)
