;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Nick Janapol"
      user-mail-address "nickjanapol@proton.me")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-zenburn)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;;Use Doom theme for Treemacs
(setq doom-themes-treemacs-theme "doom-colors")

;; Load tree-sitter
(use-package! tree-sitter
  :config
  (require 'tree-sitter-langs)
  (global-tree-sitter-mode)
  (add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode))

(use-package! highlight-numbers
  :hook (prog-mode . highlight-numbers-mode))

(use-package! rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package! highlight-quoted
  :hook (emacs-lisp-mode . highlight-quoted-mode))

;; Load lsp-mode
(use-package! lsp-mode
  :commands (lsp lsp-deferred)
  :hook ((go-mode . lsp-deferred)
         (clojure-mode . lsp-deferred)
         (clojurescript-mode . lsp-deferred)
         (clojurec-mode . lsp-deferred)
         (python-mode . lsp-deferred)
         (c-mode . lsp-deferred)
         (c++-mode . lsp-deferred))
  :init
  ;; Set prefix for lsp-command-keymap (few alternatives - "C-l", "C-c l")
  (setq lsp-keymap-prefix "C-c l")
  :config
  ;; Configure LSP clients
  (setq lsp-clients-go-server "/nick/go/bin/gopls"
        lsp-clojure-server 'clojure-lsp
        lsp-pylsp-server-command '(".env/bin/pylsp")
        lsp-clients-clangd-executable "clangd"
        lsp-enable-snippet nil
        lsp-enable-indentation nil))

;; Go mode configuration
(after! go-mode
  (setq gofmt-command "goimports")
  (add-hook 'before-save-hook 'gofmt-before-save)
  ;; Debugging LSP connection
  (add-hook 'go-mode-hook
            (lambda ()
              (message "Starting LSP for Go mode")
              (lsp-deferred))))

;; Clojure mode configuration
(after! clojure-mode
  (setq clojure-align-forms-automatically t))

;; Python mode configuration
(after! python
  (setq python-shell-interpreter "python3")
  (add-hook 'python-mode-hook
            (lambda ()
              (when (locate-dominating-file default-directory ".env")
                (pyvenv-activate (expand-file-name ".env" (project-root (project-current))))
                (lsp-deferred)))))

;; C/C++ mode configuration
(after! (c-mode c++-mode)
  (setq c-basic-offset 4))

;; Enable LSP signature help
(use-package! lsp-ui
  :commands lsp-ui-mode
  :config
  (setq lsp-ui-sideline-enable nil
        lsp-ui-doc-enable t
        lsp-ui-doc-show-with-cursor t
        lsp-ui-doc-position 'at-point))

;; Optional: LSP mode line signature help
(use-package! lsp-mode
  :config
  (setq lsp-signature-render-documentation nil))

;; Vertico integration with LSP
(use-package! consult-lsp
  :commands (consult-lsp-symbols consult-lsp-diagnostics))

(after! lsp-mode
  (setq  lsp-go-analyses '((fieldalignment . t)
                           (nilness . t)
                           (shadow . t)
                           (unusedparams . t)
                           (unusedwrite . t)
                           (useany . t)
                           (unusedvariable . t))))
