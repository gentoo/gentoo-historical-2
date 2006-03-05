# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/flim/flim-1.14.8.ebuild,v 1.1 2006/03/05 23:09:56 mkennedy Exp $

inherit elisp

IUSE=""

DESCRIPTION="A library to provide basic features about message representation or encoding -- FLIM"
HOMEPAGE="http://cvs.m17n.org/elisp/FLIM/"
SRC_URI="ftp://ftp.m17n.org/pub/mule/flim/flim-1.14/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~alpha ~sparc ~ppc ~ppc-macos ~amd64"

DEPEND="virtual/emacs
	!virtual/flim
	>=app-emacs/apel-10.3"

PROVIDE="virtual/flim"

src_compile() {
	make PREFIX=${D}/usr \
		LISPDIR=${D}/${SITELISP} \
		VERSION_SPECIFIC_LISPDIR=${D}/${SITELISP} || die
}

src_install() {
	make PREFIX=${D}/usr \
		LISPDIR=${D}/${SITELISP} \
		VERSION_SPECIFIC_LISPDIR=${D}/${SITELISP} install || die

	elisp-site-file-install ${FILESDIR}/60flim-gentoo.el

	dodoc FLIM-API.en NEWS VERSION README* ChangeLog
}
