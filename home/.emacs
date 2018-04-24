;; ��������
(menu-bar-mode -1) ;; ����ʾ�˵�
(tool-bar-mode -1) ;; ����ʾ������
(scroll-bar-mode -1) ;; ����ʾ������
(column-number-mode 1) ;; ��ʾ����������
(setq default-directory "c:/") ;; ����Ĭ��Ŀ¼
(appt-activate 1) ;; ������������
(setq require-final-newline t) ;; �༭�ļ������һ���ַ��ǻس�
(setq bookmark-default-file "~/.emacs.d/.emacs.bmk") ;; ��ǩ�ļ�λ��
(fset 'yes-or-no-p 'y-or-n-p) ;; ��ȷ��ʱ������
(global-set-key "\r" 'newline-and-indent) ;; �س�Ĭ������
(setq inhibit-startup-message t) ;; ����ʾ����ʱ�Ľ���
(show-paren-mode 1) ;; ��ʾ���ŵĶ�Ӧ������
(setq show-paren-style 'mixed) ;; ������ʾ���ŵ���ʽ
(mouse-avoidance-mode 'animate) ;; ���������غ�ʱ���ƿ����
(setq frame-title-format "%b -- Do It Yourself") ;; ���ñ���
(setq default-tab-width 4) ;; Tab �Ŀ��Ϊ 4
(setq-default make-backup-files nil) ;; �����������ļ�
(set-frame-position (selected-frame) 400 140) ;; ���ó�ʼ�Ĵ��ڿ��

;; ��ǿ find file �� switch buffer ����
(require 'ido)
(ido-mode t)

;; ���� Emacs �����´δ��ļ�ʱʹ��ͬһ�� Emacs
(server-start)

;; ���û�������
(setenv "LC_CTYPE" "zh_CN.UTF-8")

;; ����ȫ�ֿ�ݼ�
(global-set-key "\C-c\C-v" 'view-mode)  ;; ֻ��ģʽ
(global-set-key "\C-z" 'set-mark-command) ;; Mark
(global-set-key "\C-xz" 'suspend-frame) ;; �� Emacs �ŵ���̨����
(global-set-key [f8] 'occur) ;; �ڵ�ǰ Buffer �в���
(global-set-key "\C-x\C-b" 'electric-buffer-list) ;; �г���ǰ���� Buffer
(global-set-key (kbd "C--") 'undo) ;; ��ǰ�ָ�
(global-set-key "\C-c\C-z" 'pop-global-mark) ;; ��֮ǰ�� Marker
(global-set-key "\M-/" 'hippie-expand) ;; �������
(global-set-key (kbd "C-SPC") 'nil) ;; �� C+�ո� ��ݼ��ÿ�
(global-set-key "\C-ca" 'org-agenda) ;; ���� Agenda ģʽ
(global-set-key "\C-\\" 'toggle-truncate-lines) ;; �л�����ģʽ

;; ���� Windows ������
(setq w32-charset-info-alist
    (cons '("gbk" w32-charset-gb2312 . 936) w32-charset-info-alist))
(setq default-frame-alist
      (append
       '((font . "fontset-gbk")) default-frame-alist))
(create-fontset-from-fontset-spec
  "-outline-Courier New-normal-r-normal-normal-13-97-96-96-c-*-fontset-gbk")
(set-fontset-font
 "fontset-default" nil
 "-outline-������-normal-r-normal-*-14-*-96-96-c-*-iso10646-1" nil 'prepend)
(set-fontset-font
 "fontset-gbk" 'kana
 "-outline-������-normal-r-normal-*-14-*-96-96-c-*-iso10646-1" nil 'prepend)
(set-fontset-font
 "fontset-gbk" 'han
 "-outline-������-normal-r-normal-*-14-*-96-96-c-*-iso10646-1" nil 'prepend)
(set-fontset-font
 "fontset-gbk" 'cjk-misc
 "-outline-������-normal-r-normal-*-14-*-96-96-c-*-iso10646-1" nil 'prepend)
(set-fontset-font
 "fontset-gbk" 'symbol
 "-outline-������-normal-r-normal-*-14-*-96-96-c-*-iso10646-1" nil 'prepend)
(set-default-font "fontset-gbk")

;; ���� Eshell ����
;; linux �� clear
(defun eshell/clear ()
  "to clear the eshell buffer."
  (interactive)
  (let ((inhibit-read-only t))
    (erase-buffer)))

;; �� Windows �ļ��������
(defun eshell/o (&rest args)
  "open the doc"
  (interactive)
  (if (eq nil args)
      (setq args '("explorer" ".")))
  (apply 'start-process-shell-command "Sub process of Eshell" "*Messages*"
         (car args) (cdr args)))

;; �ָ�Ĭ�Ͽ������
(defun retrive-position ()
  (interactive)
  (set-frame-position (selected-frame) 400 140)
  (set-frame-size (selected-frame) 80 40))

;; ��ԭ��󻯴���
(defun frame-restore ()
  "Restore a minimized frame"
  (interactive)
  (w32-send-sys-command 61728))

;; ��󻯴���
(defun frame-maximize ()
  "Maximize the current frame"
  (interactive)
  (w32-send-sys-command 61488))

;; �ر� Buffer��֧�� Server/Client ģʽ�Ĺر�
(defun my-kill ()
  "Kill buffer for server-client and not server-client."
  (interactive)
  (cond (server-buffer-clients (server-edit))
        (t (ido-kill-buffer))))

;; ���ùر� Buffer �Ŀ�ݼ�
(global-set-key "\C-xk" 'my-kill)

;; ���� package ģ�飬����ͨ�� list-package �����չ
(require 'package)
(package-initialize)
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))

;; ���ü��ڣ��������п��Կ���
(setq calendar-holidays '((holiday-chinese 1 1 "����")
                          (holiday-chinese 1 15 "Ԫ����")
                          (holiday-fixed 3 8 "��Ů��")
                          (holiday-fixed 5 1 "�Ͷ���")
                          (holiday-fixed 6 1 "��ͯ��")
                          (holiday-chinese 5 5 "�����")
                          (holiday-chinese 7 7 "��Ϧ��")
                          (holiday-chinese 7 15 "���")
                          (holiday-fixed 8 20 "����")
                          (holiday-chinese 8 15 "�����")
                          (holiday-chinese 9 9 "������")
                          (holiday-fixed 10 1 "�����")

                          (holiday-chinese 1 1 "��������")
                          (holiday-chinese 3 1 "��������")))

(defalias 'fd 'file-cache-add-directory-recursively)
(defalias 'fc 'file-cache-clear-cache)
(defalias 'frm 'frame-maximize)
(defalias 'frr 'frame-restore)
(defalias 'of 'outline-minor-mode)
(defalias 'jf (lambda () (interactive)
				(javascript-mode)))
(defalias 'hf (lambda () (interactive)
				(html-mode)))
