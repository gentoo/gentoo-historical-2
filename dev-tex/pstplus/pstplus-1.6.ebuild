# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tex/pstplus/pstplus-1.6.ebuild,v 1.1 2011/08/22 10:21:22 radhermit Exp $

EAPI=4

inherit eutils qt4-r2

DESCRIPTION="A PSTricks GUI"
HOMEPAGE="http://www.xm1math.net/pstplus/"
SRC_URI="http://www.xm1math.net/pstplus/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="x11-libs/qt-gui:4
	x11-libs/qt-core:4
	app-text/poppler[qt4]"
RDEPEND="${DEPEND}
	virtual/latex-base
	|| (
		dev-texlive/texlive-pstricks
		app-text/ptex
	)
	app-text/psutils
	sci-visualization/gnuplot
	app-text/ghostscript-gpl
	media-libs/netpbm"

DOCS="utilities/AUTHORS"

src_install() {
	qt4-r2_src_install

	newicon utilities/pstplus48x48.png pstplus.png
	make_desktop_entry pstplus Pstplus "pstplus" Office
}

pkg_postinst() {
	elog "Examples are available at:"
	elog "/usr/share/${PN}/"
}
