;; -----------------------------------------------------------------------------
;; General config
;;
(add-to-list 'load-path "~/.emacs.d/elisp/")
(let ((default-directory  "~/.emacs.d/elisp/"))
  (normal-top-level-add-subdirs-to-load-path))

(setq inhibit-startup-message t)
(setq transient-mark-mode t)

(setq vc-follow-symlinks t)
(show-paren-mode t)

; No toolbar, could hide menus too, but they're nice sometimes
(tool-bar-mode 0)
;(menu-bar-mode 0)
(set-scroll-bar-mode nil)

;; font locking (i.e. syntax highlighting) spanning more than one line
(setq font-latex-do-multi-line t)

;; enable/disable highlighting of subscript and superscript via raised or lowered text
(setq font-latex-fontify-script nil)

;; Line numbers are good.  Getting column numbering as well is better.
(column-number-mode t)

;; Always end files in a newline.
(setq require-final-newline 't)
;; ...or ask to end in newline if needed
; (setq require-final-newline 'query)

;; Frame title bar formatting to show full path of file
(setq-default
 frame-title-format
 (list '((buffer-file-name " %f" (dired-directory
	 			  dired-directory
				  (revert-buffer-function " %b"
				  ("%b - Dir:  " default-directory)))))))

; autosave behavior
(defvar user-temporary-file-directory "~/.emacs-autosaves/")
(make-directory user-temporary-file-directory t)
(setq backup-by-copying t)
(setq backup-directory-alist
      `(("." . ,user-temporary-file-directory)
        (tramp-file-name-regexp nil)))
(setq auto-save-list-file-prefix
      (concat user-temporary-file-directory ".auto-saves-"))
(setq auto-save-file-name-transforms
      `((".*" ,user-temporary-file-directory t)))

; show column 80
(require 'fill-column-indicator)
(setq-default fill-column 80)
(setq fci-rule-color "gray20")
(add-hook 'after-change-major-mode-hook (lambda () (fci-mode 1)))

; Make cool-looking lambdas.
(require 'lambda-mode)
(setq lambda-symbol (string (make-char 'greek-iso8859-7 107)))
(add-hook 'after-change-major-mode-hook (lambda () (lambda-mode 1)))

; Sort case insensitively.
(setq sort-fold-case t)

; make buffer names more understandable
(require 'uniquify)
(setq uniquify-buffer-name-style 'reverse)
(setq uniquify-separator "|")
(setq uniquify-after-kill-buffer-p t)
(setq uniquify-ignore-buffers-re "^\\*")

; Let us grep our buffers, brothers.
(require 'grep-buffers)

;; bind rgrep to Control-g
(global-set-key (kbd "C-x g") 'rgrep)


; Change comint to allow cycling through input history using arrow keys.
(require 'comint)
(define-key comint-mode-map (kbd "M-") 'comint-next-input)
(define-key comint-mode-map (kbd "M-") 'comint-previous-input)
(define-key comint-mode-map [down] 'comint-next-matching-input-from-input)
(define-key comint-mode-map [up] 'comint-previous-matching-input-from-input)

; Autopair matching elements (parentheses, etc.).
;; (autoload 'autopair-global-mode "autopair" nil t)
;; (autopair-global-mode)
;; (add-hook 'lisp-mode-hook
;;           #'(lambda () (setq autopair-dont-activate t)))

; Delete trailing spaces when saving.
(add-hook 'before-save-hook 'delete-trailing-whitespace)

; Set up Yasnippet.
;; (require 'yasnippet)
;; (yas/initialize)
;; (yas/load-directory "~/.emacs.d/elisp/yasnippet/snippets/")

; Make browse-url use Chrome.
(setq browse-url-browser-function 'browse-url-generic
      browse-url-generic-program "google-chrome")

; Use Ido
(require 'ido)
(setq ido-enable-flex-matching t) ;; enable fuzzy matching
(setq ido-everywhere t)
(setq ido-ignore-extensions t)
(ido-mode t)

; Use SmartScan (from http://www.masteringemacs.org/articles/2011/01/14/effective-editing-movement/)
(require 'smart-scan)

; Use cycbuf and customize its keybindings
(require 'cycbuf)
(global-set-key [(ctrl next)]       'cycbuf-switch-to-next-buffer)
(global-set-key [(ctrl prior)]        'cycbuf-switch-to-previous-buffer)
;(global-set-key [(meta super right)] 'cycbuf-switch-to-next-buffer-no-timeout)
;(global-set-key [(meta super left)]  'cycbuf-switch-to-previous-buffer-no-timeout)

;; ; Load Cedet (needed for ECB)
;; (global-ede-mode 1)                      ; Enable the Project management system
;; (semantic-mode 1)

;; ; Set up ECB
;; (add-to-list 'load-path "~/.emacs.d/elisp/ecb-2.40")
;; (require 'ecb)

;; Line numbering
(setq linum-format "%4d")
(global-linum-mode 1)

; Use Auto-complete
(require 'auto-complete)
(global-auto-complete-mode t)
;; (require 'auto-complete-config nil t)
;; (define-key ac-complete-mode-map "\t" 'ac-complete)
;; (define-key ac-complete-mode-map "\r" nil)

; Focus follows mouse over buffers.
(setq mouse-autoselect-window t)

; highlight-symbol
(add-to-list 'load-path "/path/to/highlight-symbol")
(require 'highlight-symbol)

(global-set-key [(control f3)] 'highlight-symbol-at-point)
(global-set-key [f3] 'highlight-symbol-next)
(global-set-key [(shift f3)] 'highlight-symbol-prev)
(global-set-key [(meta f3)] 'highlight-symbol-prev)

;; It's magit!
(require 'magit)

;; -----------------------------------------------------------------------------
;; Keybindings
;;

; F4: Goto line
(global-set-key [f4] 'goto-line)

; F5: Refresh file
(global-set-key [f5] 'really-refresh-file)
(defun really-refresh-file ()
  (interactive)
  (revert-buffer t t t)
  )

; F6: Revert all buffers
(global-set-key [f6] 'revert-all-buffers)
(defun revert-all-buffers ()
  "Refreshes all open buffers from their respective files."
  (interactive)
  (dolist (buf (buffer-list))
    (with-current-buffer buf
      (when (and (buffer-file-name) (not (buffer-modified-p)))
	(revert-buffer t t t) )))
  (message "Refreshed open files."))

; C-M-c: Comment/uncomment region
(global-set-key (read-kbd-macro "C-M-c") 'comment-or-uncomment-region)

; misc
(global-set-key (read-kbd-macro "<insert>") 'nil)
;(global-unset-key (kbd "C-M-l"))

(require 'gimme-cat)
(global-set-key "\C-c\k" 'gimme-cat)


;; -----------------------------------------------------------------------------
;; Appearance
;;
(global-font-lock-mode t)

(set-cursor-color "white")
(set-face-background 'region "gray20")

(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(default ((t (:foreground "white" :background "black"))))
 ;; '(ecb-tag-header-face ((((class color) (background dark)) (:background "SeaGreen1" :foreground "black"))))
 '(isearch ((t (:foreground "black" :background "yellow")))))

(set-face-attribute 'default nil :height 90)



;; -----------------------------------------------------------------------------
;; Python-specific
;;
(require 'epy-init)
;;(load-file "./.emacs.d/elisp/emacs-for-python/epy-init.el")
;;(load-library "init_python")
;;(require 'python-mode)
;;(require 'ipython)

; Make it easy to insert debug statements, and highlight them.
(defun python-add-breakpoint ()
  (interactive)
  ;(py-newline-and-indent)
  (insert "import ipdb; ipdb.set_trace()")
  (highlight-lines-matching-regexp "^[ 	]*import ipdb; ipdb.set_trace()"))
(global-set-key (kbd "C-x p") 'python-add-breakpoint)

(defun annotate-pdb ()
  (interactive)
  (highlight-lines-matching-regexp "import pdb")
  (highlight-lines-matching-regexp "pdb.set_trace()"))
(add-hook 'python-mode-hook 'annotate-pdb)

; Use Pylookup to search Python docs.
(autoload 'pylookup-lookup "pylookup")
(autoload 'pylookup-update "pylookup")
(setq pylookup-program "~/.emacs.d/elisp/pylookup/pylookup.py")
(setq pylookup-db-file "~/.emacs.d/pylookup.db")
(global-set-key "\C-ch" 'pylookup-lookup)

; Make Autopair work right with single and triple quotes.
;; (add-hook 'python-mode-hook
;;           #'(lambda ()
;;               (push '(?' . ?')
;;                     (getf autopair-extra-pairs :code))
;;               (setq autopair-handle-action-fns
;;                     (list #'autopair-default-handle-action
;;                           #'autopair-python-triple-quote-action))))

; Be pedantic.
(require 'python-pep8)
(require 'python-pylint)


;; -----------------------------------------------------------------------------
;; Other mode specific
;;
(autoload 'js2-mode "js2-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))
(setq js2-mode-hook
      '(lambda () (progn
		    (set-variable 'indent-tabs-mode nil))))
(custom-set-variables
 '(js2-basic-offset 2)
 '(js2-bounce-indent-p t)
)

(add-to-list 'auto-mode-alist '("\\.xslt?$" . nxml-mode))


(require 'feature-mode)
(setq auto-mode-alist
   (cons '("\\.feature" . feature-mode) auto-mode-alist))

(autoload 'markdown-mode "markdown-mode.el"
   "Major mode for editing Markdown files" t)
(setq auto-mode-alist
   (cons '("\\.md" . markdown-mode) auto-mode-alist))

(require 'haml-mode)
(add-hook 'haml-mode-hook
	  '(lambda ()
	     (setq indent-tabs-mode nil)
	     (define-key haml-mode-map "\C-m" 'newline-and-indent)))

(require 'scss-mode)
(setq scss-sass-command "\"/usr/local/bin/sass\"")
(setq scss-compile-at-save nil)
(setq auto-mode-alist
   (cons '("\\.sass" . scss-mode) auto-mode-alist))

(require 'coffee-mode)
(defun coffee-custom ()
  "coffee-mode-hook"
  (set (make-local-variable 'tab-width) 2))
(add-hook 'coffee-mode-hook
	  '(lambda() (coffee-custom)))

;; (require 'mo-mode)
;; (setq auto-mode-alist
;;    (cons '("\\.mo" . mo-mode) auto-mode-alist))

;; (eval-after-load 'po-mode '(load "gb-po-mode"))

(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(completion-ignored-extensions (quote (".o" "~" ".bin" ".lbin" ".so" ".a" ".ln" ".blg" ".bbl" ".elc" ".lof" ".glo" ".idx" ".lot" ".svn/" ".hg/" ".git/" ".bzr/" "CVS/" "_darcs/" "_MTN/" ".fmt" ".tfm" ".class" ".fas" ".lib" ".mem" ".x86f" ".sparcf" ".fasl" ".ufsl" ".fsl" ".dxl" ".pfsl" ".dfsl" ".p64fsl" ".d64fsl" ".dx64fsl" ".lo" ".la" ".gmo" ".mo" ".toc" ".aux" ".cp" ".fn" ".ky" ".pg" ".tp" ".vr" ".cps" ".fns" ".kys" ".pgs" ".tps" ".vrs" ".pyc" ".pyo" ".egg-info"))))
;;  '(ecb-layout-window-sizes (quote (("left8" (0.11439114391143912 . 0.2692307692307692) (0.11439114391143912 . 0.23076923076923078) (0.11439114391143912 . 0.28846153846153844) (0.11439114391143912 . 0.19230769230769232)))))
;;  '(ecb-options-version "2.40")
;;  '(ecb-source-file-regexps (quote ((".*" ("\\(^\\(\\.\\|#\\)\\|\\(~$\\|\\.\\(elc\\|obj\\|o\\|class\\|lib\\|dll\\|a\\|so\\|cache\\|pyc\\)$\\)\\)") ("^\\.\\(emacs\\|gnus\\)$")))))
;;  '(ecb-source-path (quote (("~/projects/ableton.com" "new website") ("~/projects/web" "old website") ("~/projects" "all projects") ("~/env" "environment") ("~/.virtualenvs" "virtual envs") ("~/platformer" "platformer") ("~/workspace" "workspace")))))

;; (setq ecb-tip-of-the-day nil)

;; Interactively url encode/decode a string (thanks http://stackoverflow.com/questions/611831/how-to-url-decode-a-string-in-emacs-lisp)
(defun func-region (start end func)
  "run a function over the region between START and END in current buffer."
  (save-excursion
    (let ((text (delete-and-extract-region start end)))
      (insert (funcall func text)))))

(defun hex-region (start end)
  "urlencode the region between START and END in current buffer."
  (interactive "r")
  (func-region start end #'url-hexify-string))

(defun unhex-region (start end)
  "de-urlencode the region between START and END in current buffer."
  (interactive "r")
  (func-region start end #'url-unhex-string))

;;
;; Last things last....
;;
(server-start)
;; (ecb-activate)
