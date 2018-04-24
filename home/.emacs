;; 常规设置
(menu-bar-mode -1) ;; 不显示菜单
(tool-bar-mode -1) ;; 不显示工具栏
(scroll-bar-mode -1) ;; 不显示滚动条
(column-number-mode 1) ;; 显示行数和列数
(setq default-directory "c:/") ;; 设置默认目录
(appt-activate 1) ;; 启动日历提醒
(setq require-final-newline t) ;; 编辑文件的最后一个字符是回车
(setq bookmark-default-file "~/.emacs.d/.emacs.bmk") ;; 书签文件位置
(fset 'yes-or-no-p 'y-or-n-p) ;; 简化确认时的输入
(global-set-key "\r" 'newline-and-indent) ;; 回车默认缩进
(setq inhibit-startup-message t) ;; 不显示启动时的界面
(show-paren-mode 1) ;; 显示括号的对应反括号
(setq show-paren-style 'mixed) ;; 设置显示括号的样式
(mouse-avoidance-mode 'animate) ;; 光标与鼠标重合时，移开鼠标
(setq frame-title-format "%b -- Do It Yourself") ;; 设置标题
(setq default-tab-width 4) ;; Tab 的宽度为 4
(setq-default make-backup-files nil) ;; 不产生备份文件
(set-frame-position (selected-frame) 400 140) ;; 设置初始的窗口宽高

;; 增强 find file 及 switch buffer 功能
(require 'ido)
(ido-mode t)

;; 启动 Emacs 服务，下次打开文件时使用同一个 Emacs
(server-start)

;; 设置环境变量
(setenv "LC_CTYPE" "zh_CN.UTF-8")

;; 设置全局快捷键
(global-set-key "\C-c\C-v" 'view-mode)  ;; 只读模式
(global-set-key "\C-z" 'set-mark-command) ;; Mark
(global-set-key "\C-xz" 'suspend-frame) ;; 将 Emacs 放到后台运行
(global-set-key [f8] 'occur) ;; 在当前 Buffer 中查找
(global-set-key "\C-x\C-b" 'electric-buffer-list) ;; 列出当前所有 Buffer
(global-set-key (kbd "C--") 'undo) ;; 向前恢复
(global-set-key "\C-c\C-z" 'pop-global-mark) ;; 到之前的 Marker
(global-set-key "\M-/" 'hippie-expand) ;; 智能完成
(global-set-key (kbd "C-SPC") 'nil) ;; 将 C+空格 快捷键置空
(global-set-key "\C-ca" 'org-agenda) ;; 启用 Agenda 模式
(global-set-key "\C-\\" 'toggle-truncate-lines) ;; 切换换行模式

;; 设置 Windows 下字体
(setq w32-charset-info-alist
    (cons '("gbk" w32-charset-gb2312 . 936) w32-charset-info-alist))
(setq default-frame-alist
      (append
       '((font . "fontset-gbk")) default-frame-alist))
(create-fontset-from-fontset-spec
  "-outline-Courier New-normal-r-normal-normal-13-97-96-96-c-*-fontset-gbk")
(set-fontset-font
 "fontset-default" nil
 "-outline-新宋体-normal-r-normal-*-14-*-96-96-c-*-iso10646-1" nil 'prepend)
(set-fontset-font
 "fontset-gbk" 'kana
 "-outline-新宋体-normal-r-normal-*-14-*-96-96-c-*-iso10646-1" nil 'prepend)
(set-fontset-font
 "fontset-gbk" 'han
 "-outline-新宋体-normal-r-normal-*-14-*-96-96-c-*-iso10646-1" nil 'prepend)
(set-fontset-font
 "fontset-gbk" 'cjk-misc
 "-outline-新宋体-normal-r-normal-*-14-*-96-96-c-*-iso10646-1" nil 'prepend)
(set-fontset-font
 "fontset-gbk" 'symbol
 "-outline-新宋体-normal-r-normal-*-14-*-96-96-c-*-iso10646-1" nil 'prepend)
(set-default-font "fontset-gbk")

;; 增加 Eshell 命令
;; linux 中 clear
(defun eshell/clear ()
  "to clear the eshell buffer."
  (interactive)
  (let ((inhibit-read-only t))
    (erase-buffer)))

;; 用 Windows 文件浏览器打开
(defun eshell/o (&rest args)
  "open the doc"
  (interactive)
  (if (eq nil args)
      (setq args '("explorer" ".")))
  (apply 'start-process-shell-command "Sub process of Eshell" "*Messages*"
         (car args) (cdr args)))

;; 恢复默认宽高设置
(defun retrive-position ()
  (interactive)
  (set-frame-position (selected-frame) 400 140)
  (set-frame-size (selected-frame) 80 40))

;; 还原最大化窗口
(defun frame-restore ()
  "Restore a minimized frame"
  (interactive)
  (w32-send-sys-command 61728))

;; 最大化窗口
(defun frame-maximize ()
  "Maximize the current frame"
  (interactive)
  (w32-send-sys-command 61488))

;; 关闭 Buffer，支持 Server/Client 模式的关闭
(defun my-kill ()
  "Kill buffer for server-client and not server-client."
  (interactive)
  (cond (server-buffer-clients (server-edit))
        (t (ido-kill-buffer))))

;; 设置关闭 Buffer 的快捷键
(global-set-key "\C-xk" 'my-kill)

;; 加入 package 模块，可以通过 list-package 添加扩展
(require 'package)
(package-initialize)
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))

;; 设置假期，在日历中可以看到
(setq calendar-holidays '((holiday-chinese 1 1 "春节")
                          (holiday-chinese 1 15 "元宵节")
                          (holiday-fixed 3 8 "妇女节")
                          (holiday-fixed 5 1 "劳动节")
                          (holiday-fixed 6 1 "儿童节")
                          (holiday-chinese 5 5 "端午节")
                          (holiday-chinese 7 7 "七夕节")
                          (holiday-chinese 7 15 "鬼节")
                          (holiday-fixed 8 20 "纪念")
                          (holiday-chinese 8 15 "中秋节")
                          (holiday-chinese 9 9 "重阳节")
                          (holiday-fixed 10 1 "国庆节")

                          (holiday-chinese 1 1 "张三生日")
                          (holiday-chinese 3 1 "李四生日")))

(defalias 'fd 'file-cache-add-directory-recursively)
(defalias 'fc 'file-cache-clear-cache)
(defalias 'frm 'frame-maximize)
(defalias 'frr 'frame-restore)
(defalias 'of 'outline-minor-mode)
(defalias 'jf (lambda () (interactive)
				(javascript-mode)))
(defalias 'hf (lambda () (interactive)
				(html-mode)))
