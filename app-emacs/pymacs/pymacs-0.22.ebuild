# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/pymacs/pymacs-0.22.ebuild,v 1.7 2005/04/21 18:44:48 blubb Exp $

inherit distutils elisp

DESCRIPTION="Pymacs is a tool that allows both-side communication beetween Python and Emacs-lisp"
HOMEPAGE="http://pymacs.progiciels-bpi.ca"
SRC_URI="http://pymacs.progiciels-bpi.ca/archives/${P/pymacs/Pymacs}.tar.gz"

DEPEND="virtual/emacs
	virtual/python"
LICENSE="as-is"
IUSE="doc"
SLOT="0"
KEYWORDS="x86 ~ppc-macos amd64 ~ppc"

S=${WORKDIR}/Pymacs-${PV}

src_compile() {
	distutils_src_compile
	elisp-compile pymacs.el
}

src_install() {
	elisp-install ${PN} pymacs.el pymacs.elc
	elisp-site-file-install ${FILESDIR}/50pymacs-gentoo.el
	distutils_src_install
	if use doc ; then
		insinto /usr/share/doc/${PF}
		doins ./pymacs.pdf
	fi
	cd ${S}
	dodoc PKG-INFO MANIFEST README THANKS TODO THANKS-rebox ChangeLog ChangeLog-rebox
}
