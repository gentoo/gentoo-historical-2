# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/elib/elib-1.0.ebuild,v 1.10 2005/01/01 13:43:36 eradicator Exp $

inherit elisp

DESCRIPTION="The Emacs Lisp Library"
HOMEPAGE="http://jdee.sunsite.dk"
SRC_URI="http://jdee.sunsite.dk/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc amd64"
IUSE=""

DEPEND="virtual/emacs"

SITEFILE=50elib-gentoo.el

src_unpack() {
	unpack ${A}
	cd ${S}
	sed -i 's:--infodir:--info-dir:g' Makefile
}

src_compile() {
	make || die
}

src_install() {
	dodir ${SITELISP}/elib
	dodir /usr/share/info
	make prefix=${D}/usr infodir=${D}/usr/share/info install || die

	elisp-site-file-install ${FILESDIR}/${SITEFILE}

	dodoc ChangeLog INSTALL NEWS README RELEASING TODO
}

pkg_postinst() {
	elisp-site-regen
}

pkg_postrm() {
	elisp-site-regen
}
