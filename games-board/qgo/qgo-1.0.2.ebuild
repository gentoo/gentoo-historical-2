# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-board/qgo/qgo-1.0.2.ebuild,v 1.1.1.1 2005/11/30 10:10:00 chriswhite Exp $

inherit kde-functions eutils
need-qt 3

DESCRIPTION="A c++/qt go client and sgf editor"
HOMEPAGE="http://qgo.sourceforge.net/"
SRC_URI="mirror://sourceforge/qgo/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc x86"
IUSE=""

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${PV}-gcc.patch
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS ChangeLog NEWS README TODO
}
