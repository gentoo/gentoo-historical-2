# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/apel/apel-10.4.ebuild,v 1.7 2004/06/24 22:06:02 agriffis Exp $

inherit elisp

IUSE=""

DESCRIPTION="A Portable Emacs Library is a library for making portable Emacs Lisp programs."
HOMEPAGE="http://www.m17n.org/"
SRC_URI="ftp://ftp.jpl.org/pub/elisp/apel/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"

DEPEND="virtual/emacs"

src_unpack() {
	unpack ${A}
	cd ${S}
	patch -p1 <${FILESDIR}/APEL-CFG.patch || die
}

src_compile() {
	make PREFIX=${D}/usr \
		LISPDIR=${D}/${SITELISP} \
		VERSION_SPECIFIC_LISPDIR=${D}/${SITELISP} || die
}

src_install() {
	make PREFIX=${D}/usr \
		LISPDIR=${D}/${SITELISP} \
		VERSION_SPECIFIC_LISPDIR=${D}/${SITELISP} install || die

	elisp-site-file-install ${FILESDIR}/50apel-gentoo.el

	dodoc ChangeLog README*
}

pkg_postinst() {
	elisp-site-regen

	einfo "See the /usr/share/doc/${P}/README.en.gz for tips on how to customize this package"
	einfo "And you need to rebuild packages depending on ${PN}."
}

pkg_postrm() {
	elisp-site-regen
}
