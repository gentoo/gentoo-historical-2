
;;; calc site-lisp configuration

;; Emacs 22 and later include the calc package
(unless (fboundp 'calc-dispatch)
  (add-to-list 'load-path "@SITELISP@")
  (autoload 'calc-dispatch	   "calc" "Calculator Options" t)
  (autoload 'full-calc		   "calc" "Full-screen Calculator" t)
  (autoload 'full-calc-keypad	   "calc" "Full-screen X Calculator" t)
  (autoload 'calc-eval		   "calc" "Use Calculator from Lisp")
  (autoload 'defmath		   "calc" nil t t)
  (autoload 'calc		   "calc" "Calculator Mode" t)
  (autoload 'quick-calc		   "calc" "Quick Calculator" t)
  (autoload 'calc-keypad	   "calc" "X windows Calculator" t)
  (autoload 'calc-embedded	   "calc" "Use Calc inside any buffer" t)
  (autoload 'calc-embedded-activate "calc" "Activate =>'s in buffer" t)
  (autoload 'calc-grab-region	   "calc" "Grab region of Calc data" t)
  (autoload 'calc-grab-rectangle   "calc" "Grab rectangle of data" t)
  (global-set-key "\e#" 'calc-dispatch))
