# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/ocaml-mode/ocaml-mode-3.07.ebuild,v 1.2 2004/04/14 07:17:15 aliz Exp $

inherit elisp

IUSE=""
MY_P=${P/-mode/}

DESCRIPTION="Emacs mode for OCaml"
HOMEPAGE="http://www.ocaml.org/"
SRC_URI="http://caml.inria.fr/distrib/${MY_P}/${MY_P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc"
IUSE=""

DEPEND="virtual/emacs"

S="${WORKDIR}/${MY_P}/emacs"

src_compile() {
	COMPILECMD='(progn
			  (setq load-path (cons "." load-path))
			  (byte-compile-file "caml-xemacs.el")
			  (byte-compile-file "caml-emacs.el")
			  (byte-compile-file "caml.el")
			  (byte-compile-file "inf-caml.el")
			  (byte-compile-file "caml-help.el")
			  (byte-compile-file "camldebug.el"))'
	emacs -batch -eval "${COMPILECMD}"
}

src_install() {
	elisp-install ${PN} *.el *.elc
	elisp-site-file-install ${FILESDIR}/50ocaml-mode-gentoo.el
}

pkg_postinst() {
	elisp-site-regen
}

pkg_postrm() {
	elisp-site-regen
}
