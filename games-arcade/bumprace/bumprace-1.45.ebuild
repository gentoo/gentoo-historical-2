# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-arcade/bumprace/bumprace-1.45.ebuild,v 1.1 2003/09/10 19:29:21 vapier Exp $

inherit games

DESCRIPTION="simple arcade racing game"
HOMEPAGE="http://www.linux-games.com/bumprace/"
SRC_URI="http://user.cs.tu-berlin.de/~karlb/${PN}/${P}.tar.gz"

KEYWORDS="x86 ppc"
LICENSE="GPL-2"
SLOT="0"

DEPEND=">=media-libs/libsdl-1.1.5
	media-libs/sdl-mixer
	sys-libs/zlib
	media-libs/jpeg
	media-libs/libpng"

src_install() {
	egamesinstall || die
	dodoc AUTHORS ChangeLog FAQ NEWS README
	prepgamesdirs
}
