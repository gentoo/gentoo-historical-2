# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/w3/w3-4.0_pre47.ebuild,v 1.6 2004/06/24 22:27:33 agriffis Exp $

inherit elisp

DESCRIPTION="full-featured web browser written entirely in Emacs LISP"
HOMEPAGE="http://www.cs.indiana.edu/elisp/w3/docs.html"
SRC_URI="ftp://ftp.ibiblio.org/pub/packages/editors/xemacs/emacs-w3/${P/_pre/pre.}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"

DEPEND="virtual/emacs"

S="${WORKDIR}/${P/_pre/pre.}"

src_compile() {
	./configure \
		--host=${CHOST} \
		--prefix=/usr \
		--infodir=/usr/share/info \
		--mandir=/usr/share/man \
		--with-emacs \
		--with-datadir=${SITELISP}/${PN} \
		--with-lispdir=${SITELISP}/${PN} || die "./configure failed"

	# fix this up sometime
	make WIDGETDIR=/usr/share/emacs/21.2/lisp || die
}

src_install() {
	make prefix=${D}/usr \
		infodir=${D}/usr/share/info \
		datadir=${D}/${SITELISP}/${PN} \
		lispdir=${D}/${SITELISP}/${PN} install || die

	elisp-site-file-install ${FILESDIR}/50w3-gentoo.el
}

pkg_postinst() {
	elisp-site-regen
}

pkg_postrm() {
	elisp-site-regen
}
