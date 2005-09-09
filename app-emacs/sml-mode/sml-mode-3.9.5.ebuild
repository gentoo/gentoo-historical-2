# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/sml-mode/sml-mode-3.9.5.ebuild,v 1.9 2005/09/09 16:08:02 agriffis Exp $

inherit elisp

DESCRIPTION="Emacs major mode for editing Standard ML"
HOMEPAGE="ftp://ftp.research.bell-labs.com/dist/smlnj/contrib/emacs/"
SRC_URI="ftp://ftp.research.bell-labs.com/dist/smlnj/contrib/emacs/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~ppc-macos x86"
IUSE=""

SITEFILE=50sml-mode-gentoo.el

src_unpack() {
	unpack ${A}
	cat ${FILESDIR}/${SITEFILE} ${S}/sml-mode-startup.el >${WORKDIR}/${SITEFILE}
}

src_compile() {
	make || die
}

src_install() {
	elisp-install ${PN} *.el *.elc
	elisp-site-file-install ${WORKDIR}/${SITEFILE}
	doinfo *.info*
	dodoc BUGS ChangeLog NEWS README TODO INSTALL
}
