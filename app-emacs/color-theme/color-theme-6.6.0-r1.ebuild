# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/color-theme/color-theme-6.6.0-r1.ebuild,v 1.1 2009/08/10 10:06:26 ulm Exp $

inherit elisp eutils

DESCRIPTION="Install color themes (includes many themes and allows you to share your own with the world)"
HOMEPAGE="http://www.nongnu.org/color-theme/"
SRC_URI="http://mirrors.zerg.biz/nongnu/color-theme/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86 ~sparc-fbsd ~x86-fbsd"
IUSE=""

SITEFILE="50${PN}-gentoo.el"

src_unpack() {
	unpack ${A}
	rm "${S}"/*.elc "${S}"/color-theme-autoloads*
	epatch "${FILESDIR}/${P}-replace-in-string.patch"
}

src_install() {
	elisp-install ${PN} *.el *.elc || die
	elisp-install ${PN}/themes themes/*.el || die
	elisp-site-file-install "${FILESDIR}/${SITEFILE}" || die
	dodoc AUTHORS BUGS ChangeLog README || die
}

pkg_postinst() {
	elisp-site-regen
	elog "To use color-theme non-interactively, initialise it in your ~/.emacs"
	elog "as in the following example (which is for the \"Blue Sea\" theme):"
	elog "   (color-theme-initialize)"
	elog "   (color-theme-blue-sea)"
}
