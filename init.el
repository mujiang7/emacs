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



;; ;; author: pluskid
;; ;; 调用 stardict 的命令行接口来查辞典
;; ;; 如果选中了 region 就查询 region 的内容，
;; ;; 否则就查询当前光标所在的词
;; (global-set-key (kbd "C-c t") 'kid-star-dict)
;; (defun kid-star-dict ()
;;   (interactive)
;;   (let ((begin (point-min))
;;         (end (point-max)))
;;     (if mark-active
;;         (setq begin (region-beginning)
;;               end (region-end))
;;       (save-excursion
;;         (backward-word)
;;         (mark-word)
;;         (setq begin (region-beginning)
;;               end (region-end))))
;;     ;; 有时候 stardict 会很慢，所以在回显区显示一点东西
;;     ;; 以免觉得 Emacs 在干什么其他奇怪的事情。
;;     (message "searching for %s ..." (buffer-substring begin end))
;;     (tooltip-show
;;      (shell-command-to-string
;;       (concat "c:\\bdict.cmd "
;;               (buffer-substring begin end))) t)))

;; (global-set-key (kbd "C-c b") 'kid-sdcv-to-buffer)
;; (defun kid-sdcv-to-buffer ()
;;   (interactive)
;;   (let ((word (if mark-active
;;                   (buffer-substring-no-properties (region-beginning) (region-end))
;;                   (current-word nil t))))
;;     (setq word (read-string (format "Search the dictionary for (default %s): " word)
;;                             nil nil word))
;;     (set-buffer (get-buffer-create "*baidu dict*"))
;;     (buffer-disable-undo)
;;     (erase-buffer)
;;     (let ((process (start-process-shell-command "c:\\bdict.cmd" "*baidu dict*" "c:\\bdict.cmd" word)))
;;       (set-process-sentinel
;;        process
;;        (lambda (process signal)
;;          (when (memq (process-status process) '(exit signal))
;;            (unless (string= (buffer-name) "*baidu dict*")
;;              (setq kid-sdcv-window-configuration (current-window-configuration))
;;              (switch-to-buffer-other-window "*baidu dict*")
;;              (local-set-key (kbd "d") 'kid-sdcv-to-buffer)
;;              (local-set-key (kbd "q") (lambda ()
;;                                         (interactive)
;;                                         (bury-buffer)
;;                                         (unless (null (cdr (window-list))) ; only one window
;;                                           (delete-window)))))
;;            (goto-char (point-min))))))))


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

;; 
;; mew config
;;
;; (autoload 'mew "mew" nil t)
;; (autoload 'mew-send "mew" nil t)

;; ;; Optional setup (Read Mail menu for Emacs 21):
;; (if (boundp 'read-mail-command)
;;     (setq read-mail-command 'mew))

;; ;; Optional setup (e.g. C-xm for sending a message):
;; (autoload 'mew-user-agent-compose "mew" nil t)
;; (if (boundp 'mail-user-agent)
;;     (setq mail-user-agent 'mew-user-agent))
;; (if (fboundp 'define-mail-user-agent)
;;     (define-mail-user-agent
;;       'mew-user-agent
;;       'mew-user-agent-compose
;;       'mew-draft-send-message
;;       'mew-draft-kill
;;       'mew-send-hook))

;; (set-language-environment "Chinese-GBK")
;; (set-input-method "latin-1-prefix") ;; or "latin-1-postfix"


;; cc-mode-mode
;; (add-hook 'cc-mode 'lambda()(
;; 			     (c-set-style “stroustrup”)))
;; (message Man-switches)
;; (require 'man)
;; (set 'Man-switches (concat Man-switches "-a"))

;; flymake for python
;; (require 'flymake)
;; (when (load "flymake" t)
;;   (defun flymake-pyflakes-init ()
;;      ; Make sure it's not a remote buffer or flymake would not work
;;      ;; (when (not (subsetp (list (current-buffer)) (tramp-list-remote-buffers)))
;;       (let* ((temp-file (flymake-init-create-temp-buffer-copy
;;                          'flymake-create-temp-inplace))
;;              (local-file (file-relative-name
;;                           temp-file
;;                           (file-name-directory buffer-file-name))))
;;         (list "pyflakes.cmd" (list local-file))))
;;   (add-to-list 'flymake-allowed-file-name-masks
;;                '("\\.py\\'" flymake-pyflakes-init)))

;; (defun ac-python-mode-setup ()
;;   (setq ac-sources
;; 	(append '(ac-source-abbrev ac-source-features ac-source-functions
;; 				   ac-source-yasnippet ac-source-variables ac-source-symbols) 
;; 		ac-sources)))

;; (add-hook 'python-mode-hook (lambda()
;; 			      (ac-python-mode-setup)
;; 			      (flymake-mode t)
;; 			      (local-set-key [C-f1] 'flymake-display-err-menu-for-current-line)))



;; (setenv "PATH" (concat "c:/MingW/msys/1.0/bin;" (getenv "PATH")))

;; (setq ange-ftp-ftp-program-name "c:/ftp.exe")

;;;; go mode
;; (add-to-list 'load-path "C:/Go/misc/emacs" t)
;; (require 'go-mode-load)


;; python mode
;; (setq py-install-directory "~/.emacs.d/plugins/python-mode.el-6.1.0")
;; (add-to-list 'load-path py-install-directory)
;; (require 'python-mode)
;; (setq py-load-pymacs-p t)
;; (require 'auto-complete-config)
;; (ac-config-default)
;; (autoload 'company-mode "company" nil t)
;; ;; pdb setup, note the python version

;; (autoload 'pymacs-apply "pymacs")
;; (autoload 'pymacs-call "pymacs")
;; (autoload 'pymacs-eval "pymacs" nil t)
;; (autoload 'pymacs-exec "pymacs" nil t)
;; (autoload 'pymacs-load "pymacs" nil t)
;; (autoload 'pymacs-autoload "pymacs")

;; (pymacs-load "ropemacs" "rope-")
;; (setq ropemacs-enable-autoimport t)
;; (rope-project-config)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Auto-completion
;;; Integrates:
;;; 1) Rope
;;; 2) Yasnippet
;;; all with AutoComplete.el
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (defun prefix-list-elements (list prefix)
;;   (let (value)
;;     (nreverse
;;      (dolist (element list value)
;;       (setq value (cons (format "%s%s" prefix element) value))))))
;; (defvar ac-source-rope
;;   '((candidates
;;      . (lambda ()
;;          (prefix-list-elements (rope-completions) ac-target))))
;;   "Source for Rope")
;; (defun ac-python-find ()
;;   "Python `ac-find-function'."
;;   (require 'thingatpt)
;;   (let ((symbol (car-safe (bounds-of-thing-at-point 'symbol))))
;;     (if (null symbol)
;;         (if (string= "." (buffer-substring (- (point) 1) (point)))
;;             (point)
;;           nil)
;;       symbol)))
;; (defun ac-python-candidate ()
;;   "Python `ac-candidates-function'"
;;   (let (candidates)
;;     (dolist (source ac-sources)
;;       (if (symbolp source)
;;           (setq source (symbol-value source)))
;;       (let* ((ac-limit (or (cdr-safe (assq 'limit source)) ac-limit))
;;              (requires (cdr-safe (assq 'requires source)))
;;              cand)
;;         (if (or (null requires)
;;                 (>= (length ac-target) requires))
;;             (setq cand
;;                   (delq nil
;;                         (mapcar (lambda (candidate)
;;                                   (propertize candidate 'source source))
;;                                 (funcall (cdr (assq 'candidates source)))))))
;;         (if (and (> ac-limit 1)
;;                  (> (length cand) ac-limit))
;;             (setcdr (nthcdr (1- ac-limit) cand) nil))
;;         (setq candidates (append candidates cand))))
;;     (delete-dups candidates)))

;; (add-hook 'python-mode-hook
;;           (lambda ()
;;                  (auto-complete-mode 1)
;;                  (set (make-local-variable 'ac-sources)
;;                       (append ac-sources '(ac-source-rope)))
;;                  (set (make-local-variable 'ac-find-function) 'ac-python-find)
;;                  (set (make-local-variable 'ac-candidate-function) 'ac-python-candidate)
;;                  (set (make-local-variable 'ac-auto-start) nil)
;; 		 (flymake-mode t)))

;;Ryan's python specific tab completion
  ; Try the following in order:
  ; 1) Try a yasnippet expansion without autocomplete
  ; 2) If at the beginning of the line, indent
  ; 3) If at the end of the line, try to autocomplete
  ; 4) If the char after point is not alpha-numerical, try autocomplete
  ; 5) Try to do a regular python indent.
  ; 6) If at the end of a word, try autocomplete.
;; (define-key python-mode-map "\t" 'yas/expand)
;; (add-hook 'python-mode-hook
;;           (lambda ()
;;             (set (make-local-variable 'yas/trigger-fallback) 'ryan-python-expand-after-yasnippet)))
;; (defun ryan-indent ()
;;   "Runs indent-for-tab-command but returns t if it actually did an indent; nil otherwise"
;;   (let ((prev-point (point)))
;;     (indent-for-tab-command)
;;     (if (eql (point) prev-point)
;;         nil
;;       t)))
;; (defun ryan-python-expand-after-yasnippet ()
;;   (interactive)
;;   ;;2) Try indent at beginning of the line
;;   (let ((prev-point (point))
;;         (beginning-of-line nil))
;;     (save-excursion
;;       (move-beginning-of-line nil)
;;       (if (eql 0 (string-match "\\W*$" (buffer-substring (point) prev-point)))
;;           (setq beginning-of-line t)))
;;     (if beginning-of-line
;;         (ryan-indent)))
;;   ;;3) Try autocomplete if at the end of a line, or
;;   ;;4) Try autocomplete if the next char is not alpha-numerical
;;   (if (or (string-match "\n" (buffer-substring (point) (+ (point) 1)))
;;           (not (string-match "[a-zA-Z0-9]" (buffer-substring (point) (+ (point) 1)))))
;;       (ac-start)
;;     ;;5) Try a regular indent
;;     (if (not (ryan-indent))
;;         ;;6) Try autocomplete at the end of a word
;;         (if (string-match "\\W" (buffer-substring (point) (+ (point) 1)))
;;             (ac-start)))))

;; ;; End Tab completion


;; ;;Workaround so that Autocomplete is by default is only invoked explicitly,
;; ;;but still automatically updates as you type while attempting to complete.
;; (defadvice ac-start (before advice-turn-on-auto-start activate)
;;   (set (make-local-variable 'ac-auto-start) t))
;; (defadvice ac-cleanup (after advice-turn-off-auto-start activate)
;;   (set (make-local-variable 'ac-auto-start) nil))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; End Auto Completion
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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
