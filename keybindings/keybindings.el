;;; Commentary:

;; This file is a keybinding collections for GNU Emacs.
;; Type of keybindings in this file consists of normal and hydra keybindings
;; For the details in hydra, kindly refer hydra.el or
;; visit https://github.com/abo-abo/hydra#pre-and-post


;; key-chord support mainly for hydra keybindings
(require 'key-chord)
(key-chord-mode 1)

;; key bindings for multiple cursors
(defhydra hydra-multiple-cursors (:color pink)
  "
^
  ^H-mc^              ^mc-Atomic^                 ^mc-Line^               ^mc-Region^
──^────^──────────────^─────────^─────────────────^───────^───────────────^─────────^─────────────
_q_ quit       _n_ mark-next-like-this         _a_ edit-lines      _C->_ mark-all-like-this
^^             _p_ mark-previous-like-this     ^^
^^             ^^                              ^^
"
  ("q" nil)
  ("a" mc/edit-lines)
  ("n" mc/mark-next-like-this)
  ("p" mc/mark-previous-like-this)
  ("C->" mc/mark-all-like-this :color blue))

(global-set-key (kbd "C-c C-m") 'hydra-multiple-cursors/body)

;; key bindings for switch-window
(defhydra hydra-switch-window (:color pink)
  "
^
  ^H-sw^             ^sw-Switch^                ^sw-Split^            ^sw-Delete^
──^────^─────────────^─────────^────────────────^────────^────────────^─────────^──────────────
_q_ quit       _o_ switch-window             _2_ split-below      _0_ delete-window
^^             _1_ switch-then-maximize      _3_ split-right      ^^
^^             _;_ other-window              ^^                   ^^
^^             ^^                            ^^                   ^^
"
  ("q" nil)
  ("o" switch-window)
  ("1" switch-window-then-maximize)
  ("2" switch-window-then-split-below)
  ("3" switch-window-then-split-right)
  ("0" switch-window-then-delete)
  (";" other-window))

(global-set-key (kbd "C-;") 'hydra-switch-window/body)


;;;; zoom text with hydra keybindings
;; (key-chord-define-global
;;  "tt"
;;  (defhydra hydra-zoom (:color pink)
;;   "
;;   ^H-Zoom^            ^z-Enlarge^             ^z-Diminish^
;; ──^──────^────────────^─────────^─────────────^──────────^────────────────
;; _q_ quit            _g_ increase             _l_ decrease
;; ^^                  ^^                       ^^
;; "
;;   ("q" nil)
;;   ("g" text-scale-increase "in")
;;   ("l" text-scale-decrease "out")))


;; helm commands with hydra keybindings
(defhydra hydra-helm (:color blue)
  "
^
  ^H-Helm^              ^h-Search^              ^h-File^             ^h-List^
──^──────^──────────────^────────^──────────────^──────^─────────────^──────^───
_q_ quit            _g_ google              _C-f_ find-files        _c_ colors
^^                  _i_ imenu               _f_ multi-files
^^                  _a_ apropos             ^^
^^                  _o_ occur               ^^
^^                  _r_ regex-builder       ^^
^^                  _M-x_ Interaction       ^^
^^                  ^^                      ^^
"
  ("q" nil)
  ("c" helm-colors)
  ("a" helm-apropos)
  ("M-x" helm-M-x)
  ("C-f" helm-find-files)
  ("f" helm-multi-files)
  ("g" helm-google-suggest)
  ("i" helm-imenu)
  ("o" helm-occur)
  ("r" helm-regexp))

(key-chord-define-global "xc" 'hydra-helm/body)


;; Apropos with hydra keybindings
(defhydra hydra-apropos (:color blue
                         :hint nil)
  "
^
  ^H-Apropos^          ^ap-Doc & Var^          ^ap-Commands^
──^─────────^──────────^────────────^──────────^───────────^────────────
_q_ quit            _a_ apropos              _c_ command
^^                  _d_ documentation        _l_ library
^^                  _v_ variable             _u_ user-option
^^                  _e_ value                ^^
^^                  ^^                       ^^
"
  ("q" nil)
  ("a" apropos)
  ("d" apropos-documentation)
  ("v" apropos-variable)
  ("c" apropos-command)
  ("l" apropos-library)
  ("u" apropos-user-option)
  ("e" apropos-value))

(global-set-key (kbd "C-c h") 'hydra-apropos/body)


;; highlight-symbol with hydra keybindings
(global-set-key
 (kbd "M-<f3>")
 (defhydra hydra-highlight-symbol
   (:color pink)
   "
^
  ^h-Highlight-Symbol^        ^hls-All^               ^hls-Atomic^
──^──────────────────^────────^───────^───────────────^──────────^────────────
_q_ quit                  _a_ highlight-all       _n_ next
^^                        ^^                      _p_ previous
^^                        ^^                      _r_ query-replace
^^                        ^^                      ^^
"
   ("q" nil)
   ("a" highlight-symbol)
   ("n" highlight-symbol-next)
   ("p" highlight-symbol-prev)
   ("r" highlight-symbol-query-replace)))


;; helm key-bindings
(define-key global-map [remap occur] 'helm-occur)
(define-key global-map [remap list-buffers] 'helm-buffers-list)
(define-key global-map [remap dabbrev-expand] 'helm-dabbrev)
(global-set-key (kbd "M-x") 'helm-M-x)
(unless (boundp 'completion-in-region-function)
  (define-key lisp-interaction-mode-map [remap completion-at-point] 'helm-lisp-completion-at-point)
  (define-key emacs-lisp-mode-map [remap completion-at-point] 'helm-lisp-completion-at-point))

;;; keybindings.el ends here
