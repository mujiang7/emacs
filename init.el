;; -*- coding:utf-8 -*-

(add-to-list 'load-path "~/.emacs.d/plugins")
;; (ido-mode t)
(defun my-font-existsp (font)
  (if (null (x-list-fonts font))
      nil t))

(defun my-make-font-string (font-name font-size)
  (if (and (stringp font-size)
           (equal ":" (string (elt font-size 0))))
      (format "%s%s" font-name font-size)
    (format "%s %s" font-name font-size)))


(defun my-set-font (english-fonts
                       english-font-size
                       chinese-fonts
                       &optional chinese-font-size)
  "english-font-size could be set to \":pixelsize=18\" or a integer.
If set/leave chinese-font-size to nil, it will follow english-font-size"
  (require 'cl)                         ; for find if
  (let ((en-font (my-make-font-string
                  (find-if #'my-font-existsp english-fonts)
                  english-font-size))
        (zh-font (font-spec :family (find-if #'my-font-existsp chinese-fonts)
                            :size chinese-font-size)))
 
    ;; Set the default English font
    ;;
    ;; The following 2 method cannot make the font settig work in new frames.
    ;; (set-default-font "Consolas:pixelsize=18")
    ;; (add-to-list 'default-frame-alist '(font . "Consolas:pixelsize=18"))
    ;; We have to use set-face-attribute
    (message "Set English Font to %s" en-font)
    (set-face-attribute
     'default nil :font en-font)
 
    ;; Set Chinese font
    ;; Do not use 'unicode charset, it will cause the english font setting invalid
    (message "Set Chinese Font to %s" zh-font)
    (dolist (charset '(kana han symbol cjk-misc bopomofo))
      (set-fontset-font (frame-parameter nil 'font)
                        charset
                        zh-font))))

(my-set-font
 '("Monaco" "Consolas" "DejaVu Sans Mono" "Monospace" "Courier New") ":pixelsize=16"
 '("Microsoft Yahei" "文泉驿等宽微米黑" "黑体" "新宋体" "宋体"))


(defun my-comment-dwim-line (&optional arg)
  "Replacement for the comment-dwim command.
If no region is selected and current line is not blank and we are not at the end of the line,
then comment current line.
Replaces default behaviour of comment-dwim, when it inserts comment at the end of the line."
  (interactive "*P")
  (comment-normalize-vars)
  (if (and (not (region-active-p)) (not (looking-at "[ \t]*$")))
      (comment-or-uncomment-region (line-beginning-position) (line-end-position))
    (comment-dwim arg)))
(global-set-key "\M-;" 'my-comment-dwim-line)

;;设置界面
(set-foreground-color "white")
(set-background-color "black")
(set-cursor-color "gold1")
(set-mouse-color "gold1")

(set-scroll-bar-mode nil)

;;显示时间
(display-time-mode 1);;启用时间显示设置，在minibuffer上面的那个杠上
(setq display-time-24hr-format t);;时间使用24小时制
(setq display-time-day-and-date t);;时间显示包括日期和具体时间
;; (setq display-time-use-mail-icon t);;时间栏旁边启用邮件设置
(setq display-time-interval 30);;时间的变化频率，

(setq inhibit-startup-message t)
(setq scroll-margin 3 scroll-conservatively 10000)
(setq visible-bell t)
(setq line-number-mode t)
(setq frame-title-format "%b@emacs")
(setq global-font-lock-mode t)
(setq make-backup-files nil)
;; 设定不产生备份文件
(setq auto-save-mode nil)
;;自动保存模式
(setq-default make-backup-files nil)
;; 不生成临时文件

;(global-set-key [home] 'beginning-of-buffer)
;(global-set-key [end] 'end-of-buffer)

(global-set-key (kbd "C-SPC") 'nil)
(global-set-key (kbd "C-\`") 'iswitchb-buffer)
(global-set-key [C-f4] 'kill-buffer)
;; (tool-bar-mode nil)
(setq default-major-mode 'text-mode)
(global-set-key (kbd "C-c C-S-c") 'uncomment-region)
(global-set-key (kbd "C-S-SPC") 'set-mark-command)
;(put 'upcase-region 'disabled nil)
(global-set-key [C-tab] 'other-window)
(global-set-key [f9] 'compile)

;---- yasnippet --
(add-to-list 'load-path "~/.emacs.d/plugins/yasnippet")
(require 'yasnippet)
(yas/initialize)
(yas/load-directory "~/.emacs.d/plugins/yasnippet/snippets")
(yas/global-mode 1)

;;;; auto-complete plug in
;; (add-to-list 'load-path "~/.emacs.d/plugins/auto-complete-1.3.1")
;; (require 'auto-complete-config)
;; (add-to-list 'ac-dictionary-directories "~/.emacs.d/plugins/auto-complete-1.3.1/ac-dict")
;; (ac-config-default)
;; (setq ac-ignore-case t)
;; (setq ac-auto-start 2)
;; (setq ac-dwim t)

(defalias 'yes-or-no-p 'y-or-n-p)
(defalias 'perl-mode 'cperl-mode)
(add-hook 'cperl-mode-hook '(lambda()
			      (local-set-key [M-f1] 'cperl-perldoc)))

(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)

(server-mode 1)
(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(abbrev-mode t)
 '(case-fold-search nil)
 '(column-number-mode t)
 '(default-major-mode (quote text-mode) t)
 '(delete-selection-mode t)
 '(display-time-mode t)
 '(ecb-compile-window-height 6)
 '(ecb-compile-window-width (quote edit-window))
 '(ecb-options-version "2.40")
 '(ecb-source-path (quote (("c:" "c:"))))
 '(ecb-tip-of-the-day nil)
 '(icomplete-mode t)
 '(initial-scratch-message nil)
 '(iswitchb-mode t)
 '(mew-use-cached-passwd t)
 '(mew-use-master-passwd nil)
 '(semantic-c-dependency-system-include-path (quote ("/usr/include" "/usr/src/linux/include")))
 '(tool-bar-mode nil))
 ;; '(shell-file-name "c:\\mingw\\msys\\1.0\\bin\\bash.exe"))
; '(ecb-options-version "2.40"))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "black" :foreground "white" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 158 :width normal :foundry "unknown" :family "DejaVu Sans Mono")))))

;; Load CEDET.
;; See cedet/common/cedet.info for configuration details.
(load-file "~/.emacs.d/plugins/cedet-1.0/common/cedet.el")
(add-to-list 'load-path "~/.emacs.d/plugins/ecb-2.40/")
(require 'ecb)
(require 'semantic)
;; (semantic-load-enable-minimum-features)
;; (semantic-load-enable-code-helpers)
;; (semantic-load-enable-guady-code-helpers)
(semantic-load-enable-excessive-code-helpers)
(semantic-load-enable-semantic-debugging-helpers)
;; (semantic-add-system-include "/usr/src/linux/include")
(global-set-key [f12] 'semantic-ia-fast-jump)
(global-set-key [M-/] 'semantic-ia-complete-symbol-menu)
