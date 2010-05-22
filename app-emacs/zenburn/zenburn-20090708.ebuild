# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/zenburn/zenburn-20090708.ebuild,v 1.3 2010/05/22 15:55:53 pacho Exp $

inherit elisp

DESCRIPTION="Zenburn color theme for Emacs"
HOMEPAGE="http://slinky.imukuppi.org/zenburnpage/"
# taken from: http://www.brockman.se/software/zenburn/zenburn.el
SRC_URI="mirror://gentoo/${P}.el.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="app-emacs/color-theme"
RDEPEND="${DEPEND}"

SITEFILE="50${PN}-gentoo.el"

pkg_postinst() {
	elisp-site-regen
	elog "To enable zenburn by default, initialise it in your ~/.emacs:"
	elog "   (color-theme-zenburn)"
}
