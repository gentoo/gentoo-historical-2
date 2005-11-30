
;;; xslide site-lisp configuration

(setq load-path (cons "@SITELISP@" load-path))
(autoload 'xsl-mode "xslide" "Major mode for XSL stylesheets." t)
;; Turn on font lock when in XSL mode
(add-hook 'xsl-mode-hook
	  'turn-on-font-lock)
(setq auto-mode-alist
      (append
       (list
	'("\\.fo" . xsl-mode)
	'("\\.xsl" . xsl-mode))
       auto-mode-alist))
