# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-arcade/stardork/stardork-0.6.ebuild,v 1.4 2004/12/21 14:30:09 nigoro Exp $

inherit games

DESCRIPTION="An ncurses-based space shooter"
HOMEPAGE="http://stardork.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc ~ppc64"
IUSE=""

DEPEND="sys-libs/ncurses"

src_install() {
	dogamesbin stardork || die "dogamesbin failed"
	dodoc README
	prepgamesdirs
}
