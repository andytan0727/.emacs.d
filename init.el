(require 'package)
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (url (concat (if no-ssl "http" "https") "://melpa.org/packages/")))
  (add-to-list 'package-archives (cons "melpa" url) t))

(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "https://elpa.gnu.org/packages/")))

(package-initialize)

;; fullscreen during startup
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;; Modern machines don't need to run GC for every 8MB allocated.
(setq gc-cons-threshold 20000000)

;; ensure use-package macro is installed
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-and-compile
  (defvar use-package-verbose t)
  (require 'cl)
  (require 'use-package)
  (require 'bind-key)
  (require 'diminish)
  (setq use-package-always-ensure t))

;; checks and report Emacs config errors
(use-package validate
  :demand t)

;; Keep .emacs.d clean
;; store files in ~/.emacs.d/var or ~/.emacs.d/etc
(use-package no-littering
  :ensure t
  :config
  (require 'recentf)
  (add-to-list 'recentf-exclude no-littering-var-directory)
  (add-to-list 'recentf-exclude no-littering-etc-directory))

;; load .secret.el
(load "~/.emacs.d/.secret.el")

;; load keybindings file
(add-to-list 'load-path "~/.emacs.d/keybindings")  ;; load key-chord.el in keybindings folder
(load "~/.emacs.d/keybindings/keybindings.el")
;;(load "c:/Users/andytan/AppData/Roaming/.emacs.d/keybindings/keybindings.el")

;; add themes folder to custom-theme-load-path
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")

;; different themes interchangeably with others
;;-------------------------------------------
;; dark themes:
;;(load-theme 'sanityinc-tomorrow-eighties t)
(load-theme 'sanityinc-tomorrow-night t)
;;(load-theme 'sanityinc-tomorrow-bright t)
;;(load-theme 'zenburn t)
;;(load-theme 'gruvbox-dark-soft t)
;;(load-theme 'gruvbox-dark-medium t)
;;(load-theme 'gruvbox-dark-hard t)
;;(require 'solarized-dark-theme)
;;(load-theme 'wheatgrass-hybrid t)

;; light themes
;;(load-theme 'sanityinc-tomorrow-day t)
;;(require 'solarized-light-theme)
;;(load-theme 'gruvbox-light-soft t)
;;(load-theme 'gruvbox-light-medium t)
;;(load-theme 'gruvbox-light-hard t)
;;-------------------------------------------


;; load .custom.el file
(setq-default custom-file (expand-file-name ".custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))

;; default browser
(setq browse-url-browser-function 'browse-url-generic
      browse-url-generic-program "google-chrome-stable")

(when window-system
  (blink-cursor-mode 0)                           ; Disable the cursor blinking
  (scroll-bar-mode 0)                             ; Disable the scroll bar
  (tool-bar-mode 0)                               ; Disable the tool bar
  (tooltip-mode 0))                               ; Disable the tooltips

;; backup directory
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

;; delete all backup files that are older than a certain date
(message "Deleting old backup files...")
(let ((week (* 60 60 24 7))
      (current (float-time (current-time))))
  (dolist (file (directory-files temporary-file-directory t))
    (when (and (backup-file-name-p file)
               (> (- current (float-time (fifth (file-attributes file))))
                  week))
      (message "%s" file)
      (delete-file file))))

;; Allow access from emacsclient
(require 'server)
(unless (server-running-p)
  (server-start))


(setq-default
 ad-redefinition-action 'accept                  ;; Silence warnings for redefinition
 confirm-kill-emacs 'yes-or-no-p                 ;; Confirm before exiting Emacs
 cursor-in-non-selected-windows t                ;; Hide the cursor in inactive windows
 delete-by-moving-to-trash t                     ;; Delete files to trash
 display-time-default-load-average nil           ;; Don't display load average
 display-time-format "%H:%M"                     ;; Format the time string
 fill-column 80                                  ;; Set width for automatic line breaks
 indent-tabs-mode nil                            ;; Stop using tabs to indent
 inhibit-startup-screen t                        ;; Disable start-up screen
 inhibit-startup-message t                       ;; Disable start-up message
 inhibit-splash-screen t                         ;; remove splash screen
 initial-scratch-message ""                      ;; Empty the initial *scratch* buffer
 left-margin-width 1 right-margin-width 1        ;; Add left and right margins
 ns-use-srgb-colorspace nil                      ;; Don't use sRGB colors
 recenter-positions '(5 top bottom)              ;; Set re-centering positions
 scroll-conservatively most-positive-fixnum      ;; Always scroll by one line
 scroll-margin 10                                ;; Add a margin when scrolling vertically
 sentence-end-double-space nil                   ;; End a sentence after a dot and a space
 show-trailing-whitespace nil                    ;; Display trailing whitespaces
 split-height-threshold nil                      ;; Disable vertical window splitting
 split-width-threshold nil                       ;; Disable horizontal window splitting
 ring-bell-function 'ignore                      ;; ignore alarm
 tab-width 4                                     ;; Set width for tabs
 uniquify-buffer-name-style 'forward             ;; Uniquify buffer names
 window-combination-resize t                     ;; Resize windows proportionally
 c-basic-offset 4                                ;; tab-space size during CC-mode
 python-indent-offset 4)                         ;; tab-space size for python-mode
(delete-selection-mode)                          ;; Replace region when inserting text
(display-time-mode)                              ;; Enable time in the mode-line
(fringe-mode 0)                                  ;; Hide fringes
(fset 'yes-or-no-p 'y-or-n-p)                    ;; Replace yes/no prompts with y/n
(global-hl-line-mode)                            ;; Hightlight current line
(mouse-avoidance-mode 'banish)                   ;; Avoid collision of mouse with point
(put 'downcase-region 'disabled nil)             ;; Enable downcase-region
(put 'upcase-region 'disabled nil)               ;; Enable upcase-region
;;(xclip-mode 1)                                   ;; Enable copy/paste from clipboard in -nw mode
(show-paren-mode)                                ;; Turn on parenthesis matching mode

(add-hook 'focus-out-hook #'garbage-collect)     ;; Garbage-collection on focus out (makes Emacs snappier)

;; encoding
(prefer-coding-system 'utf-8)

(setq coding-system-for-read 'utf-8)
(setq coding-system-for-write 'utf-8)

(load "~/.emacs.d/Font-Awesome-for-Emacs.el")
;;(load "c:/Users/andytan/AppData/Roaming/.emacs.d/Font-Awesome-for-Emacs.el")


;; smooth-scrolling
(add-to-list 'load-path "~/.emacs.d/smooth-scroll")
;;(add-to-list 'load-path "c:/Users/andytan/AppData/Roaming/.emacs.d/smooth-scroll")
(require 'smooth-scroll)
(smooth-scroll-mode t)

;; add space seperation between line number and the buffer contents
(add-hook 'prog-mode-hook 'linum-mode)  ;; Show line numbers in prog-mode only
(add-hook 'conf-space-mode-hook 'linum-mode)
(add-hook 'LaTeX-mode-hook 'linum-mode)
(setq linum-format "%4d ")  ;; %4d means it reserves 4 spaces for displaying numbers

;; load autopair and enable it to be global
(add-to-list 'load-path "~/.emacs.d/autopair")
;;(add-to-list 'load-path "c:/Users/andytan/AppData/Roaming/.emacs.d/autopair")
(require 'autopair)
(autopair-global-mode)  ;; enable autopair in all buffers

;; create new scratch buffer (mode-specific)
(use-package scratch
  :ensure t
  :bind ("C-c b" . scratch))

;; yasnippet
(require 'yasnippet)
(yas-global-mode 1)

;; colorize colors as text with their value
(use-package rainbow-mode
  :init (add-hook 'prog-mode-hook #'rainbow-mode)
  :config (setq-default rainbow-x-colors-major-mode-list '()))

;; show battery life at mode-line
(add-hook 'after-init-hook #'fancy-battery-mode)
(setq fancy-battery-show-percentage t)

;; when invoked with M-x sudo, uses TRAMP to edit the current file as root
(defun sudo ()
  "Use TRAMP to `sudo' the current buffer"
  (interactive)
  (when buffer-file-name
    (find-alternate-file
     (concat "/sudo:root@localhost:"
             buffer-file-name))))


;;--------------------------------------------------
;;                                                 |
;;                    delight                      |
;;                                                 |
;;--------------------------------------------------
(require 'delight)
(delight '((abbrev-mode "Abv" abbrev)
           (eldoc-mode nil "eldoc")
           (autopair-mode nil t)
           (rainbow-mode)
           (auto-dim-other-buffers-mode nil auto-dim-other-buffers)
           (golden-ratio-mode nil "golden-ratio")
           (company-mode "com" company)
           (helm-mode)
           (yas-minor-mode nil yasnippet)
           (smooth-scroll-mode nil smooth-scroll)
           (emacs-lisp-mode "Elisp" :major)))


;;--------------------------------------------------
;;                                                 |
;;                  helm-mode                      |
;;                                                 |
;;--------------------------------------------------
(require 'helm-config)
(use-package helm
  :defer 1
  :config
  (helm-mode)
  (setq-default
   helm-always-two-windows t
   helm-display-header-line nil)
  (add-hook 'helm-after-persistent-action-hook
            '(lambda () (recenter-top-bottom (car recenter-positions))))
  (add-hook 'helm-after-action-hook
            '(lambda () (recenter-top-bottom (car recenter-positions))))
  (set-face-attribute 'helm-action nil :underline nil)
  (set-face-attribute 'helm-match nil :background nil)
  (set-face-attribute 'helm-source-header nil
                      :box nil
                      :background nil))


;;--------------------------------------------------
;;                                                 |
;;                   paradox                       |
;;                                                 |
;;--------------------------------------------------
;; Project for modernizing Emacs’ Package Menu
(require 'paradox)
(paradox-enable)

(use-package paradox
  :config
  (setq-default paradox-execute-asynchronously t)
  (remove-hook 'paradox--report-buffer-print 'paradox-after-execute-functions))


;;--------------------------------------------------
;;                                                 |
;;                   spaceline                     |
;;                                                 |
;;--------------------------------------------------
;; configure the mode-line
(setq-default
 mode-line-format '("%e" (:eval (spaceline-ml-main)))
;; powerline-default-separator 'wave
 powerline-height 20
 spaceline-highlight-face-func 'spaceline-highlight-face-modified  ;; status of the current buffer (modified, unmodified or read-only).
 spaceline-flycheck-bullet "❖ %s"
 spaceline-separator-dir-left '(left . left)
 spaceline-separator-dir-right '(right . right))

;; mode-line theme
(require 'spaceline-config)
(spaceline-emacs-theme)


;;--------------------------------------------------
;;                                                 |
;;                   ido-mode                      |
;;                                                 |
;;--------------------------------------------------
(setq ido-enable-flex-matching t
      ido-everywhere t
      ido-create-new-buffer 'always)  ;; force ido to always create a new buffer if the namedoes not exist
(ido-mode 1)  ;; enable ido-mode globally


;;--------------------------------------------------
;;                                                 |
;;                flycheck general                 |
;;                                                 |
;;--------------------------------------------------
(require 'flycheck)
(add-hook 'after-init-hook #'global-flycheck-mode)  ;; flycheck activated globally

(setq-default flycheck-disabled-checkers '(emacs-lisp-checkdoc))


;;--------------------------------------------------
;;                                                 |
;;                company general                  |
;;                                                 |
;;--------------------------------------------------
(require 'company)
(add-hook 'after-init-hook 'global-company-mode)

(use-package company
  :defer 1
  :config
  (global-company-mode)
  (setq-default
   company-idle-delay .2
   company-tooltip-limit 20
   company-minimum-prefix-length 1
   company-begin-commands '(self-insert-command)
   company-require-match nil
   company-tooltip-align-annotations t))

(use-package company-dabbrev
  :ensure nil
  :after company
  :config (setq-default company-dabbrev-downcase nil))

(add-hook 'after-init-hook 'company-statistics-mode)

;;--------------------------------------------------
;;                                                 |
;;                switch-window                    |
;;                                                 |
;;--------------------------------------------------
;; auto-resize window when switch to it
(setq switch-window-auto-resize-window t)
(setq switch-window-default-window-size 0.8)  ;;80% of frame size


;;--------------------------------------------------
;;                                                 |
;;                 golden-ratio                    |
;;                                                 |
;;--------------------------------------------------
;; auto-resize focused window
(require 'golden-ratio)
(golden-ratio-mode 1)

;;;; to prevent golden-ratio activate in certain mode
(setq golden-ratio-exclude-modes '("ediff-mode"
                                   "eshell-mode"
                                   "cider-repl-mode"))


;;--------------------------------------------------
;;                                                 |
;;                 font-awesome                    |
;;                                                 |
;;--------------------------------------------------
(propertize "" 'face '(:family "FontAwesome"))

;;--------------------------------------------------
;;                                                 |
;;                   Markdown                      |
;;                                                 |
;;--------------------------------------------------
(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))


;;--------------------------------------------------
;;                                                 |
;;                   Projectile                    |
;;                                                 |
;;--------------------------------------------------
;;(projectile-global-mode)
(setq projectile-enable-caching t)

;; disable remote file exists cache
(setq projectile-file-exists-remote-cache-expire nil)

;; if a project is selected
;; top-level directory of the project is immediately opened for you in a dired buffer
(setq projectile-switch-project-action 'projectile-dired)


;;--------------------------------------------------
;;                                                 |
;;                     aucTeX                      |
;;                                                 |
;;--------------------------------------------------
;(add-to-list 'load-path "~/.emacs.d/site-lisp/auctex-11.91")
;; (load "auctex.el" nil t t)
;; (load "preview-latex.el" nil t t)


;;--------------------------------------------------
;;                                                 |
;;                    Python                       |
;;                                                 |
;;--------------------------------------------------
;; triple quoting in python mode
;; (add-hook 'python-mode-hook
;;            #'(lambda ()
;;                (setq autopair-handle-action-fns
;;                      (list #'autopair-default-handle-action
;;                            #'autopair-python-triple-quote-action))))

(elpy-enable)


;;--------------------------------------------------
;;                                                 |
;;                     C/C++                       |
;;                                                 |
;;--------------------------------------------------
;; to have '<' and '>' pairing in C-mode
(add-hook 'c-mode-hook
           #'(lambda ()
               (push '(?< . ?>)
                     (cl-getf autopair-extra-pairs :code))))

;; source code completion using clang
;; need to create a .dir.locals.el file in project root with the following contents:
;; ((nil . ((company-clang-arguments . ("-I/home/<user>/project_root/include1/"
;;                                      "-I/home/<user>/project_root/include2/")))))
(setq company-backends (delete 'company-semantic company-backends))
(add-to-list 'company-backends 'company-c-headers)  ;; header completion
(add-hook 'c-mode-hook (lambda () (rainbow-mode 0)))


;;--------------------------------------------------
;;                                                 |
;;                    clojure                      |
;;                                                 |
;;--------------------------------------------------
;; This is useful for working with camel-case tokens, like names of
;; Java classes (e.g. JavaClassName)
(add-hook 'clojure-mode-hook 'subword-mode)

;; rainbow delimiter for clojure-mode
(add-hook 'clojure-mode-hook 'rainbow-delimiters-mode)

;; A little more syntax highlighting
(require 'clojure-mode-extra-font-locking)

;; syntax hilighting for midje
(add-hook 'clojure-mode-hook
          (lambda ()
            (setq inferior-lisp-program "lein repl")
            (font-lock-add-keywords
             nil
             '(("(\\(facts?\\)"
                (1 font-lock-keyword-face))
               ("(\\(background?\\)"
                (1 font-lock-keyword-face))))
            (define-clojure-indent (fact 1))
            (define-clojure-indent (facts 1))))

;; provides minibuffer documentation for the code you're typing into the repl
;;(add-hook 'cider-mode-hook 'cider-turn-on-eldoc-mode)

;; go right to the REPL buffer when it's finished connecting
(setq cider-repl-pop-to-buffer-on-connect t)

;; When there's a cider error, show its buffer and switch to it
(setq cider-show-error-buffer t)
(setq cider-auto-select-error-buffer t)

;; Where to store the cider history.
(setq cider-repl-history-file "~/.emacs.d/cider-history")

;; Wrap when navigating history.
(setq cider-repl-wrap-history t)

;; enable autopair in REPL
(add-hook 'cider-repl-mode-hook 'autopair-mode)

;; Use clojure mode for other extensions
(add-to-list 'auto-mode-alist '("\\.edn$" . clojure-mode))
(add-to-list 'auto-mode-alist '("\\.boot$" . clojure-mode))
(add-to-list 'auto-mode-alist '("\\.cljs.*$" . clojure-mode))
(add-to-list 'auto-mode-alist '("lein-env" . enh-ruby-mode))


;;--------------------------------------------------
;;                                                 |
;;                    Web mode                     |
;;                                                 |
;;--------------------------------------------------
(require 'web-mode)
(require 'company-web-html)

;; Enable JavaScript completion between <script>...</script> etc.
(defadvice company-tern (before web-mode-set-up-ac-sources activate)
  "Set `tern-mode' based on current language before running company-tern."
  (if (equal major-mode 'web-mode)
      (let ((web-mode-cur-language
             (web-mode-language-at-pos)))
        (if (or (string= web-mode-cur-language "javascript")
                (string= web-mode-cur-language "jsx"))
            (unless tern-mode 
              (tern-mode))
          (if tern-mode (tern-mode -1))))))

(defun andy/web-mode-hook ()
  "personal customization hook for web-mode"

  ;; indent offset for web-mode
  (setq web-mode-code-indent-offset 2
        web-mode-css-indent-offset 2
        web-mode-markup-indent-offset 2
        web-mode-enable-auto-pairing t
        web-mode-engines-alist '(("php"    . "\\.phtml\\'")
                                 ("blade"  . "\\.blade\\."))
        web-mode-enable-comment-keywords t
        web-mode-enable-current-element-highlight t
        web-mode-enable-current-column-highlight t)

  ;; company for tern and html
  (set (make-local-variable 'company-backends)
       '(company-tern company-web-html company-yasnippet company-files)))

(add-hook 'web-mode-hook 'andy/web-mode-hook)

(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))

;; toogle between php-mode and web-mode for editing embedded php
(defun andy/toggle-php-web-mode ()
  "Switch between php-mode and web-mode for the current buffer."
  (interactive)
  (if (equal (symbol-name (buffer-local-value 'major-mode (current-buffer))) "web-mode")
      (php-mode)
    (web-mode)))


;;--------------------------------------------------
;;                                                 |
;;                     php                         |
;;                                                 |
;;--------------------------------------------------
(require 'php-auto-yasnippets)
(define-key php-mode-map (kbd "C-c C-y") 'yas/create-php-snippet)

(flycheck-define-checker andy/php-checker
  "A PHP syntax checker using the PHP command line interpreter.
   See URL `http://php.net/manual/en/features.commandline.php'."
  :command ("php" "-l" "-d" "error_reporting=E_ALL" "-d" "display_errors=1"
            "-d" "log_errors=0" source)
  :error-patterns
  ((error line-start (or "Parse" "Fatal" "syntax") " error" (any ":" ",") " "
          (message) " in " (file-name) " on line " line line-end))
  :modes (php-mode php+-mode web-mode))

(add-to-list 'load-path "~/.emacs.d/php-extras")
;;(add-to-list 'load-path "c:/Users/andytan/AppData/Roaming/.emacs.d/php-extras")
(require 'php-extras)

(defun andy/company-php ()
  "personal config for company-php"
  (require 'company-php)
  (company-mode t)
  ;;(ac-php-core-eldoc-setup) ;; enable eldoc
  (make-local-variable 'company-backends)
  (add-to-list 'company-backends 'company-ac-php-backend))

;; personal setup for php document
(defun andy/setup-php ()
  (andy/company-php)
  (flycheck-select-checker 'andy/php-checker)
  (flycheck-mode t))

(add-hook 'php-mode-hook 'andy/setup-php)

;; add customized php setup to php-mode
(add-to-list 'auto-mode-alist '("\\.php?\\'" . php-mode))


;;--------------------------------------------------
;;                                                 |
;;                    emmet                        |
;;                                                 |
;;--------------------------------------------------
(require 'emmet-mode)
(add-hook 'web-mode-hook 'emmet-mode) ;; Auto-start on any markup modes
(add-hook 'css-mode-hook  'emmet-mode) ;; enable Emmet's css abbreviation.

;; disable indent-region
(add-hook 'emmet-mode-hook (lambda () (setq emmet-indent-after-insert nil)))

 ;; indent 2 spaces.
(add-hook 'emmet-mode-hook (lambda () (setq emmet-indentation 2)))

;; cursor to be positioned between first empty quotes after expanding
(setq emmet-move-cursor-between-quotes t)

;; default "/"
;; only " /", "/" and "" are valid.
;; eg. <meta />, <meta/>, <meta>
(setq emmet-self-closing-tag-style " /")




;;--------------------------------------------------
;;                                                 |
;;                   JavaScript                    |
;;                                                 |
;;--------------------------------------------------
;; major mode for JavaScript editing
(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
(setq js2-highlight-level 3)  ;; syntax highligting level

;;syntax checking
(add-hook 'js2-mode-hook
          (lambda () (flycheck-mode t)))

;; disable jshint (use eslint instead)
(setq-default flycheck-disabled-checkers
              (append flycheck-disabled-checkers '(javascript-jshint)))

;; include Node.js externs in the master externs list
;; makes eslint does not recognize function like setTimeout as undef-variable or function
(setq js2-include-node-externs t)

;; use eslint with web-mode for jsx files
(flycheck-add-mode 'javascript-eslint 'js2-mode)

;; company for js2-mode
(use-package company-tern
  :after company
  :config
  (add-to-list 'company-backends 'company-tern)
  (setq-default
   company-tern-meta-as-single-line t
   company-tern-property-marker " *"))

;; Tern for javaScript
;; Tern-autocomplete for js
(add-hook 'js2-mode-hook (lambda () (tern-mode t)))
(eval-after-load 'tern
   '(progn
      (require 'tern-auto-complete)
      (tern-ac-setup)))

;;  hook it in for shell scripting via node.js
(add-to-list 'interpreter-mode-alist '("node" . js2-mode))


;;--------------------------------------------------
;;                                                 |
;;                  Common Lisp                    |
;;                                                 |
;;--------------------------------------------------
(defun andy/ac-common-lisp-mode ()
  (setq ac-sources '(ac-source-filename
                     ac-source-functions
                     ac-source-variables
                     Ac-source-features
                     ac-source-symbols
                     ac-source-slime
                     ac-source-words-in-same-mode-buffers))
  (add-to-list 'ac-modes 'lisp-mode)
  (auto-complete-mode 1))

(add-hook 'lisp-mode-hook 'andy/ac-common-lisp-mode)

;; init.el ends here
