# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/jde/jde-2.3.2.ebuild,v 1.1 2003/01/31 19:09:19 mkennedy Exp $

inherit elisp

IUSE=""

DESCRIPTION="Java Development Environment for Emacs"
HOMEPAGE="http://jdee.sunsite.dk/"
SRC_URI="mirror://gentoo/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"

DEPEND="virtual/emacs
	>=virtual/jdk-1.2
	app-emacs/eieio
	app-emacs/semantic
	app-emacs/elib"

S="${WORKDIR}/${P}"

src_compile() {
	cd ${S}/lisp
	rm -f jde-compile-script-init
	for i in ${SITELISP}/eieio ${SITELISP}/semantic ${PWD}
	do
		echo "(add-to-list 'load-path \"$i\")" >>jde-compile-script-init
	done
	emacs -batch -l jde-compile-script-init -f batch-byte-compile *.el
}

src_install() {
	dodir ${SITELISP}/${PN}
	cp -r java ${D}/${SITELISP}/${PN}/

	dodir /usr/share/doc/${P}
	cp -r doc/* ${D}/usr/share/doc/${P}/

	cd ${S}/lisp
	elisp-install ${PN}/lisp *.el *.elc *.bnf

	elisp-site-file-install ${FILESDIR}/70jde-gentoo.el
	exeinto /usr/bin
	doexe jtags*
	dodoc ChangeLog ReleaseNotes.txt
}

pkg_postinst() {
	elisp-site-regen
}

pkg_postrm() {
	elisp-site-regen
}
