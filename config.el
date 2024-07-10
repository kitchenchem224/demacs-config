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
;;(setq doom-font (font-spec :family "FiraCode Nerd Font" :size 14)
;;doom-variable-pitch-font (font-spec :family "ETBembo" :size 14)
;;      doom-variable-pitch-font (font-spec :family "Alegreya" :size 14))

;;
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

;; Allow mixed fonts in a buffer.
(add-hook! 'org-mode-hook #'mixed-pitch-mode)
(add-hook! 'org-mode-hook #'solaire-mode)
(setq mixed-pitch-variable-pitch-cursor nil)
(after! org (setq org-hide-emphasis-markers t))
(after! org (setq org-insert-heading-respect-content nil))

;; Enable logging of done tasks, and log into LOGBOOK drawer by default.
(after! org
  (setq org-log-done t)
  (setq org-log-into-drawer t))

;; Enable speed keys to use single-key commands when the cursor is placed on a heading, not also at the beginning of a headline
;; line. This makes them active on any asterisk at the beginning of the line.
;;(after! org
;; (setq org-use-speed-commands
;;        (lambda ()
;;          (and (looking-at org-outline-regexp)
;;               (looking-back "^\**")))))

;; Disable electric-mode to avoid weird indentations.
(add-hook! org-mode (electric-indent-local-mode -1))


;; ENable visual line and variable line mode in Org by default.
(add-hook! org-mode :append
           #'visual-line-mode
           #'variable-pitch-mode)

;; Where all the org-captured sutff is found
(after! org
  (setq org-agenda-files
        '("~/gtd" "~/Work/work.org.gpg" "~/org/")))

;; Let attachments get stored with their corresponding org doc.
(setq org-attach-id-dir "attachments/")

;; Org-roam. Not sure how to get this to work great.
;; (setq org-roam-directory "~/Pcloud/org-roam/")
;; (setq +org-roam-open-buffer-on-find-file t)

;; Use org-archive so I actually feel like I am getting stuff done.
(use-package! org-archive
  :after org
  :config
  (setq org-archive-location "archive.org::datetree/"))

;; If I really want to be neurotic and time myself use this.
;;(after! org-clock
;; (setq org-clock-persist t)
;;  (org-clock-persistence-insinuate))

;; Auto-save and backup files.
;; (setq auto-save-default t
;;       make-backup-files t)

;; Disable exit prompt.
(setq confirm-kill-emacs nil)

;;Use Doom theme for Treemacs
(setq doom-themes-treemacs-theme "doom-colors")

;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
;;
;;
;;; ~/.doom.d/config.el

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
  (setq lsp-clients-go-server "gopls"
        lsp-clojure-server 'clojure-lsp
        lsp-pylsp-server-command "pylsp"
        lsp-clients-clangd-executable "clangd")

  ;; Custom LSP settings can be added here
  (setq lsp-enable-snippet nil ;; Disable snippets, if you don't use them
        lsp-enable-indentation nil ;; Disable indentation for languages where you don't want it
        ))

;; Go mode configuration
(after! go-mode
  (setq gofmt-command "goimports")
  (add-hook 'before-save-hook 'gofmt-before-save))

;; Clojure mode configuration
(after! clojure-mode
  (setq clojure-align-forms-automatically t))

;; Python mode configuration
(after! python
  (setq python-shell-interpreter "python3"))

;; C/C++ mode configuration
(after! (c-mode c++-mode)
  (setq c-basic-offset 4))

;; Enable LSP signature help
(use-package! lsp-ui
  :commands lsp-ui-mode
  :config
  (setq lsp-ui-sideline-enable nil ;; Disable sideline help, if you don't want it
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

;; Disable ligatures I don't want/like or don't work.
(plist-put! +ligatures-extra-symbols
            :and           nil
            :or            nil
            :for           nil
            :not           nil
            :true          nil
            :false         nil
            :int           nil
            :float         nil
            :str           nil
            :bool          nil
            :list          nil
            )

(let ((ligatures-to-disable '(:true :false :int :float :str :bool :list :and :or :for :not)))
  (dolist (sym ligatures-to-disable)
    (plist-put! +ligatures-extra-symbols sym nil)))

;; Show word count in modeline for modes from doom-modeline-continuos-word-count-modes (org & Markdown etc.)
(setq doom-modeline-enable-word-count t)

;; Better undo/redo?
;; (after! undo-fu
;;  (map! :map undo-fu-mode-map "C-?" #'undo-fu-only-redo))
