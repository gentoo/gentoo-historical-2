# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-fps/aaut/aaut-1.ebuild,v 1.1.1.1 2005/11/30 09:39:43 chriswhite Exp $

inherit games

DESCRIPTION="ascii mode unreal tournament"
HOMEPAGE="http://icculus.org/~chunky/ut/aaut/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE=""

RDEPEND="virtual/libc
	|| (
		games-fps/unreal-tournament
		games-fps/unreal-tournament-goty )
	media-libs/aalib"

src_install() {
	dogamesbin "${FILESDIR}/aaut" || die "dogamesbin failed"
	prepgamesdirs
}
