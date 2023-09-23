;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
(setq doom-font (font-spec :family "Hack Nerd Font" :size 12)
     doom-variable-pitch-font (font-spec :family "Hack Nerd Font" :size 13)
     doom-big-font (font-spec :family "Hack Nerd Font" :size 15))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


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

(use-package! eaf
  ;; 设定只有手动调用以下命令后，eaf才会加载
  :commands (eaf-open eaf-open-bookmark eaf-open-browser eaf-open-browser-with-history)
  :init
  ;; 设定emacs中打开链接默认使用eaf打开
  (setq browse-url-browser-function 'eaf-open-browser)
  (defalias 'browse-web #'eaf-open-browser)
  ;; 定义了一个用于开启eaf debug模式的函数
  (defun +eaf-enable-debug ()
    (interactive)
      (setq eaf-enable-debug t))
  ;; :custom
  ;; ;; 设定eaf代理
  ;; (eaf-proxy-type "socks5")
  ;; (eaf-proxy-host "127.0.0.1")
  ;; (eaf-proxy-port "1086")
  :config
  ;; 下面的require都是引入你已经安装的eaf扩展
  (require 'eaf-image-viewer)
  ;; (require 'eaf-demo)
  ;; (require 'eaf-git)
  (require 'eaf-browser)
  (require 'eaf-pdf-viewer)

  ;; (require 'eaf-evil)
  ;; 使得在eaf buffer下能正常使用evil的keymap
  (define-key key-translation-map (kbd "SPC")
    (lambda (prompt)
      (if (derived-mode-p 'eaf-mode)
          (pcase eaf--buffer-app-name
            ("browser" (if  (string= (eaf-call-sync "call_function" eaf--buffer-id "is_focus") "True")
                           (kbd "SPC")
                         (kbd eaf-evil-leader-key)))
            ("pdf-viewer" (kbd eaf-evil-leader-key))
            ("image-viewer" (kbd eaf-evil-leader-key))
            (_  (kbd "SPC")))
        (kbd "SPC"))))
  ;; 设定eaf默认搜索引擎
  (setq eaf-browser-default-search-engine "google")
  ;; 设定eaf开启广告屏蔽器
  (setq eaf-browser-enable-adblocker t)
  ;; 设定eaf浏览器的缩放
  (setq eaf-browser-default-zoom 1.2)
  ;; 修复鼠标乱跑的问题，让她一直放在左下角
  (setq mouse-avoidance-banish-position '((frame-or-window . frame)
                                          (side . right)
                                          (side-pos . 100)
                                          (top-or-bottom . bottom)
                                          (top-or-bottom-pos . -100)))
  (mouse-avoidance-mode 'banish))
