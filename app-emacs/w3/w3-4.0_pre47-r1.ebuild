# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/w3/w3-4.0_pre47-r1.ebuild,v 1.12 2005/04/21 18:34:55 blubb Exp $

inherit elisp

DESCRIPTION="full-featured web browser written entirely in Emacs Lisp"
HOMEPAGE="http://www.cs.indiana.edu/elisp/w3/docs.html"
SRC_URI="ftp://ftp.ibiblio.org/pub/packages/editors/xemacs/emacs-w3/${P/_pre/pre.}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 sparc alpha ~ppc amd64"
IUSE=""

DEPEND="virtual/emacs"

S="${WORKDIR}/${P/_pre/pre.}"

src_unpack() {
	unpack ${A}
	cd ${S} && patch -p1 <${FILESDIR}/w3-gentoo.patch || die
}

src_compile() {
	./configure \
		--host=${CHOST} \
		--prefix=/usr \
		--infodir=/usr/share/info \
		--mandir=/usr/share/man \
		--with-emacs \
		--with-datadir=${SITELISP}/${PN} \
		--with-lispdir=${SITELISP}/${PN} || die "./configure failed"
	make || die
}

src_install() {
	make prefix=${D}/usr infodir=${D}/usr/share/info datadir=${D}/${SITELISP}/${PN} \
		lispdir=${D}/${SITELISP}/${PN} install || die
	elisp-site-file-install ${FILESDIR}/50w3-gentoo.el
}
