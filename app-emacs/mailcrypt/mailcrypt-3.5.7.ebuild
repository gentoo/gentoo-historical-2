# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/mailcrypt/mailcrypt-3.5.7.ebuild,v 1.5 2004/06/24 22:17:39 agriffis Exp $

inherit elisp

IUSE=""

DESCRIPTION="Provides a simple interface to public key cryptography with PGP [and now GnuPG!]."
HOMEPAGE="http://mailcrypt.sourceforge.net/"
SRC_URI="mirror://sourceforge/mailcrypt/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"

DEPEND="virtual/emacs"
RDEPEND="${DEPEND}
	app-crypt/gnupg"

src_compile() {
	EMACS=emacs ./configure --prefix=/usr || die
	make || die
}

src_install() {
	make prefix=${D}/usr \
		infodir=${D}/usr/share/info install \
		lispdir=${D}/${SITELISP}/${PN} || die
	elisp-site-file-install ${FILESDIR}/50mailcrypt-gentoo.el
	dodoc ANNOUNCE ChangeLog* INSTALL LCD-entry mailcrypt.dvi NEWS ONEWS README*
}

pkg_postinst() {
	elisp-site-regen
	einfo ""
	einfo "See /usr/share/doc/${P}/INSTALL.gz for how to customize mailcrypt"
	einfo ""
}

pkg_postrm() {
	elisp-site-regen
}
