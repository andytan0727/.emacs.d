;; set default font and font size
(add-to-list 'default-frame-alist
             '(font . "Monaco-12"))

;; setting when not in GUI mode
(when (not (display-graphic-p))
  (load-theme 'zenburn t)
  (menu-bar-mode 0))


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("5673c365c8679addfb44f3d91d6b880c3266766b605c99f2d9b00745202e75f6" "4528fb576178303ee89888e8126449341d463001cb38abe0015541eb798d8a23" default)))
 '(package-selected-packages
   (quote
    (elpy ov fontawesome auctex lua-mode php-extras company-statistics php-auto-yasnippets markdown-mode company-web company-php emmet-mode php-mode web-mode rainbow-delimiters clojure-mode-extra-font-locking projectile skewer-mode cider gruvbox-theme delight helm eyebrowse fancy-battery spaceline async rainbow-mode auto-dim-other-buffers paradox highlight-symbol scratch no-littering xclip validate use-package tern-auto-complete switch-window solarized-theme multiple-cursors js2-mode irony golden-ratio flycheck company-try-hard company-tern company-quickhelp company-c-headers common-lisp-snippets color-theme-sanityinc-tomorrow))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(whitespace-space ((t (:foreground "darkgray")))))
