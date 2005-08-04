;;; -*- mode: lisp; syntax: common-lisp; package: common-lisp -*-

(defpackage #:swank-system
  (:use #:common-lisp
        #:asdf))

(defpackage #:swank-loader
  (:use #:common-lisp))

(in-package #:swank-system)

;; http://www.caddr.com/macho/archives/sbcl-devel/2004-3/3014.html

(defclass unsafe-file (cl-source-file) ())

(defmethod perform :around ((op compile-op) (c unsafe-file))
  (setf (operation-on-warnings op) :ignore
        (operation-on-failure op) :warn) ; adjust to taste
  (call-next-method))

(defmacro define-swank-system (&rest sysdep-components)
  `(defsystem swank
       :name "Swank is the Common Lips back-end to SLIME"
       :serial t
       :components ((:file "swank-backend")
                    (:file "nregex")
                    ,@(mapcar #'(lambda (component)
                                  (if (atom component)
                                      (list :file component)
                                      component))
                              sysdep-components)
                    (:file "swank"))
       :depends-on (#+sbcl sb-bsd-sockets)))

#+sbcl  (define-swank-system
	  "swank-sbcl"
	  "swank-source-path-parser"
	  "swank-source-file-cache" 
	  "swank-gray")

#+openmcl (define-swank-system
	    "metering"
	    "swank-openmcl"
	    "swank-gray")

#+cmu (define-swank-system
	"swank-source-path-parser" 
	"swank-source-file-cache"
	"swank-cmucl")

#+clisp (define-swank-system
	  "xref"
	  "metering"
	  "swank-clisp"
	  "swank-gray")

#+armedbear (define-swank-system
		"swank-abcl")

#+ecl (define-swank-system
	  "swank-ecl" "swank-gray")

(in-package #:swank-loader)

(defun user-init-file ()
  "Return the name of the user init file or NIL if it does not exist."
  (probe-file (merge-pathnames (user-homedir-pathname)
                               (make-pathname :name ".swank" :type "lisp"))))

(defun site-init-file ()
  "Return the name of the site init file or NIL if it does not exist."
  (probe-file (make-pathname :name "site-init" :type "lisp" :defaults *load-truename*)))

(or  (when (site-init-file)
       (load (site-init-file)))
     (when (user-init-file)
       (load (user-init-file))))

;; swank.asd ends here
