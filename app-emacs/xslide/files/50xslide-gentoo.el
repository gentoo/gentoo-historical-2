
;;; xslide site-lisp configuration

(add-to-list 'load-path "@SITELISP@")
(autoload 'xsl-mode "xslide" "Major mode for XSL stylesheets." t)
;; Turn on font lock when in XSL mode
(add-hook 'xsl-mode-hook
	  'turn-on-font-lock)
(setq auto-mode-alist
      (append
       (list
	'("\\.fo$" . xsl-mode)
	'("\\.xsl" . xsl-mode))
       auto-mode-alist))
