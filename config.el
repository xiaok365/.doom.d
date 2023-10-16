(beacon-mode 1)

;; (pushnew! initial-frame-alist '(width . 200) '(height . 55))
(add-hook 'window-setup-hook #'toggle-frame-maximized)
;; (add-hook 'window-setup-hook #'toggle-frame-fullscreen)

(setq url-proxy-services
   '(("no_proxy" . "^\\(localhost\\|10\\..*\\|192\\.168\\..*\\)")
     ("http" . "127.0.0.1:1087")
     ("https" . "127.0.0.1:1087")))

(set-frame-parameter (selected-frame) 'alpha '(95 95))
(add-to-list 'default-frame-alist '(alpha 95 95))

(map! :leader
      (:prefix ("e" . "open file")
       :desc "Edit agenda file"      "a" #'(lambda () (interactive) (find-file "~/Documents/org/agenda.org"))
       :desc "Edit elfeed file"      "e" #'(lambda () (interactive) (find-file "~/Documents/org/elfeed.org"))
       :desc "Edit travel file"      "t" #'(lambda () (interactive) (find-file "~/Documents/org/travel.org"))
       :desc "Edit englis file"      "l" #'(lambda () (interactive) (find-file "~/Documents/org/english.org"))
       :desc "Edit doom config.org"  "c" #'(lambda () (interactive) (find-file "~/.config/doom/config.org"))
       :desc "Edit doom init.el"     "i" #'(lambda () (interactive) (find-file "~/.config/doom/init.el"))
       :desc "Edit doom packages.el" "p" #'(lambda () (interactive) (find-file "~/.config/doom/packages.el"))))

(setq http-proxy "http://127.0.0.1:1087")
(setq elfeed-goodies/entry-pane-size 0.5)
(use-package mb-url-http
  ;; :load-path "~/.emacs.d/mb-url"
  :defer t
  :commands (mb-url-http-around-advice)
  :init
  (setq mb-url-http-backend 'mb-url-http-curl
        mb-url-http-curl-switches `("--max-time" "20" "-x" ,http-proxy))
  (advice-add 'url-http :around 'mb-url-http-around-advice))
;; Automatically updating feed when opening elfeed
;; (add-hook! 'elfeed-search-mode-hook #'elfeed-update)

(setq doom-font (font-spec :family "Hack Nerd Font" :size 15 :weight 'normal)
     doom-variable-pitch-font (font-spec :family "Hack Nerd Font" :size 15 :weight 'normal)
     doom-big-font (font-spec :family "Hack Nerd Font" :size 18 :weight 'normal))

(setq doom-theme 'doom-xcode)

(setq display-line-numbers-type 'relative)

(setq delete-by-moving-to-trash t
      trash-directory "~/Trash/")

(after! counsel
  (setq counsel-rg-base-command
        "rg -M 240 --hidden --with-filename --no-heading --line-number --color never %s"))

(setq org-babel-default-header-args
      (cons '(:tangle . "yes")
            (assq-delete-all :tangle org-babel-default-header-args)))

;; (map! :leader
;;       :desc "Org babel tangle" "m B" #'org-babel-tangle)

(custom-set-faces
  '(org-level-1 ((t (:inherit outline-1 :height 1.7))))
  '(org-level-2 ((t (:inherit outline-2 :height 1.6))))
  '(org-level-3 ((t (:inherit outline-3 :height 1.5))))
  '(org-level-4 ((t (:inherit outline-4 :height 1.4))))
  '(org-level-5 ((t (:inherit outline-5 :height 1.3))))
  '(org-level-6 ((t (:inherit outline-6 :height 1.2))))
  '(org-level-7 ((t (:inherit outline-7 :height 1.1))))
  '(org-level-8 ((t (:inherit outline-8 :height 1.0))))
)

(after! org
  (setq org-directory "~/Documents/org/"
        org-default-notes-file (expand-file-name "notes.org" org-directory)
        org-ellipsis " ▼ "
        org-superstar-headline-bullets-list '("◉" "●" "○" "◆" "●" "○" "◆")
        org-superstar-itembullet-alist '((?+ . ?➤) (?- . ?✦)) ; changes +/- symbols in item lists
        org-log-done 'time
        org-hide-emphasis-markers t
        ;; ex. of org-link-abbrev-alist in action
        ;; [[arch-wiki:Name_of_Page][Description]]
        org-link-abbrev-alist    ; This overwrites the default Doom org-link-abbrev-list
          '(("google" . "http://www.google.com/search?q=")
            ("arch-wiki" . "https://wiki.archlinux.org/index.php/")
            ("ddg" . "https://duckduckgo.com/?q=")
            ("wiki" . "https://en.wikipedia.org/wiki/"))
        org-table-convert-region-max-lines 20000
        org-todo-keywords        ; This overwrites the default Doom org-todo-keywords
          '((sequence
             "TODO(t)"           ; A task that is ready to be tackled
             "BLOG(b)"           ; Blog writing assignments
             "GYM(g)"            ; Things to accomplish at the gym
             "PROJ(p)"           ; A project that contains other tasks
             "VIDEO(v)"          ; Video assignments
             "WAIT(w)"           ; Something is holding up this task
             "|"                 ; The pipe necessary to separate "active" states and "inactive" states
             "DONE(d)"           ; Task has been completed
             "CANCELLED(c)" )))) ; Task has been cancelled

(after! org
  (setq org-agenda-files '("~/Documents/org/agenda.org")))
(setq
   ;; org-fancy-priorities-list '("[A]" "[B]" "[C]")
   ;; org-fancy-priorities-list '("❗" "[B]" "[C]")
   org-fancy-priorities-list '("🟥" "🟧" "🟨")
   org-priority-faces
   '((?A :foreground "#ff6c6b" :weight bold)
     (?B :foreground "#98be65" :weight bold)
     (?C :foreground "#c678dd" :weight bold))
   org-agenda-block-separator 8411)

(setq org-agenda-custom-commands
      '(("v" "A better agenda view"
         ((tags "PRIORITY=\"A\""
                ((org-agenda-skip-function '(org-agenda-skip-entry-if 'todo 'done))
                 (org-agenda-overriding-header "High-priority unfinished tasks:")))
          (tags "PRIORITY=\"B\""
                ((org-agenda-skip-function '(org-agenda-skip-entry-if 'todo 'done))
                 (org-agenda-overriding-header "Medium-priority unfinished tasks:")))
          (tags "PRIORITY=\"C\""
                ((org-agenda-skip-function '(org-agenda-skip-entry-if 'todo 'done))
                 (org-agenda-overriding-header "Low-priority unfinished tasks:")))
          (tags "customtag"
                ((org-agenda-skip-function '(org-agenda-skip-entry-if 'todo 'done))
                 (org-agenda-overriding-header "Tasks marked with customtag:")))

          (agenda "")
          (alltodo "")))))

(require 'sublimity)
(require 'sublimity-scroll)
;; (require 'sublimity-map) ;; experimental
;; (require 'sublimity-attractive)

(sublimity-mode 1)
(setq sublimity-scroll-weight 5
      sublimity-scroll-drift-length 10)
(setq sublimity-scroll-vertical-frame-delay 0.01)

;; (setq sublimity-map-size 20)
;; (setq sublimity-map-fraction 0.3)
;; (setq sublimity-map-text-scale -7)
;; (sublimity-map-set-delay nil)

;; (setq sublimity-attractive-centering-width 110)
;;
;; (sublimity-attractive-hide-bars)
;; (sublimity-attractive-hide-vertical-border)
;; (sublimity-attractive-hide-fringes)
;; (sublimity-attractive-hide-modelines)

(custom-set-faces!
'(markdown-header-delimiter-face :foreground "#616161" :height 0.9)
'(markdown-header-face-1 :height 1.7 :foreground "#A3BE8C" :weight extra-bold :inherit markdown-header-face)
'(markdown-header-face-2 :height 1.6 :foreground "#EBCB8B" :weight extra-bold :inherit markdown-header-face)
'(markdown-header-face-3 :height 1.5 :foreground "#D08770" :weight extra-bold :inherit markdown-header-face)
'(markdown-header-face-4 :height 1.4 :foreground "#BF616A" :weight bold :inherit markdown-header-face)
'(markdown-header-face-5 :height 1.3 :foreground "#b48ead" :weight bold :inherit markdown-header-face)
'(markdown-header-face-6 :height 1.2 :foreground "#5e81ac" :weight semi-bold :inherit markdown-header-face))

;; (use-package markdown-mode :ensure t
;;   :init
;;   (setq-default markdown-hide-markup t))

(defun prefer-horizontal-split ()
  (set-variable 'split-height-threshold nil t)
  (set-variable 'split-width-threshold 40 t)) ; make this as low as needed
(add-hook 'markdown-mode-hook 'prefer-horizontal-split)
(map! :leader
      :desc "Clone indirect buffer other window" "b c" #'clone-indirect-buffer-other-window)

(when (featurep! :lang java +lsp)
  (setq lsp-java-maven-download-sources t
        lsp-java-autobuild-enabled nil
        lsp-java-selection-enabled nil
        lsp-java-code-generation-use-blocks t
        lsp-java-code-generation-generate-comments t
        lsp-java-code-generation-to-string-code-style "STRING_BUILDER")

  ;; Lombok support
  ;; See https://github.com/redhat-developer/vscode-java/wiki/Lombok-support
  (after! lsp-java
    (push (concat "-javaagent:"
                  (expand-file-name "~/.local/share/nvim/mason/packages/jdtls/lombok.jar"))
          lsp-java-vmargs))

  ;; Groovy
  (add-hook 'groovy-mode-local-vars-hook #'lsp!))

(map! :map dap-mode-map
      :leader
      :prefix ("d" . "dap")
      ;; basics
      :desc "dap next"          "n" #'dap-next
      :desc "dap step in"       "i" #'dap-step-in
      :desc "dap step out"      "o" #'dap-step-out
      :desc "dap continue"      "c" #'dap-continue
      :desc "dap hydra"         "h" #'dap-hydra
      :desc "dap debug restart" "r" #'dap-debug-restart
      :desc "dap debug"         "s" #'dap-debug

      ;; debug
      :prefix ("dd" . "Debug")
      :desc "dap debug recent"  "r" #'dap-debug-recent
      :desc "dap debug last"    "l" #'dap-debug-last

      ;; eval
      :prefix ("de" . "Eval")
      :desc "eval"                "e" #'dap-eval
      :desc "eval region"         "r" #'dap-eval-region
      :desc "eval thing at point" "s" #'dap-eval-thing-at-point
      :desc "add expression"      "a" #'dap-ui-expressions-add
      :desc "remove expression"   "d" #'dap-ui-expressions-remove

      :prefix ("db" . "Breakpoint")
      :desc "dap breakpoint toggle"      "b" #'dap-breakpoint-toggle
      :desc "dap breakpoint condition"   "c" #'dap-breakpoint-condition
      :desc "dap breakpoint hit count"   "h" #'dap-breakpoint-hit-condition
      :desc "dap breakpoint log message" "l" #'dap-breakpoint-log-message)

(define-key evil-motion-state-map (kbd "C-h") #'evil-window-left)
(define-key evil-motion-state-map (kbd "C-j") #'evil-window-down)
(define-key evil-motion-state-map (kbd "C-k") #'evil-window-up)
(define-key evil-motion-state-map (kbd "C-l") #'evil-window-right)

(defvar-local my-flycheck-local-cache nil)
(defun my-flycheck-local-checker-get (fn checker property)
  ;; Only check the buffer local cache for the LSP checker, otherwise we get
  ;; infinite loops.
  (if (eq checker 'lsp)
      (or (alist-get property my-flycheck-local-cache)
          (funcall fn checker property))
    (funcall fn checker property)))
(advice-add 'flycheck-checker-get
            :around 'my-flycheck-local-checker-get)
(add-hook 'lsp-managed-mode-hook
          (lambda ()
            (when (derived-mode-p 'go-mode)
              (setq my-flycheck-local-cache '((next-checkers . (golangci-lint)))))))
