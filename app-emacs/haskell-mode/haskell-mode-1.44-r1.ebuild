# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/haskell-mode/haskell-mode-1.44-r1.ebuild,v 1.8 2005/06/05 11:38:26 hansmi Exp $

inherit elisp

IUSE=""

DESCRIPTION="Mode for editing (and running) Haskell programs in Emacs"
HOMEPAGE="http://www.haskell.org/haskell-mode/"
SRC_URI="http://www.haskell.org/haskell-mode/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"

DEPEND="virtual/emacs"

SITEFILE="50${PN}-gentoo.el"

src_install() {
	elisp_src_install
	dohtml *.html *.hs
}

pkg_postinst() {
	elisp_pkg_postinst
	einfo "See /usr/share/doc/${P}/html/installation-guide.html"
}
