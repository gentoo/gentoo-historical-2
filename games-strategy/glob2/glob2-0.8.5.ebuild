# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-strategy/glob2/glob2-0.8.5.ebuild,v 1.4 2004/07/01 05:34:11 mr_bones_ Exp $

inherit games

DESCRIPTION="state of the art Real Time Strategy (RTS) game"
HOMEPAGE="http://www.ysagoon.com/glob2/"
SRC_URI="http://www.ysagoon.com/glob2/data/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc"
#IUSE="opengl" #opengl not ready yet.
IUSE=""

DEPEND="virtual/libc
	>=media-libs/libsdl-1.2.0
	media-libs/libpng
	media-libs/sdl-net
	media-libs/sdl-image
	media-libs/libvorbis
	=media-libs/freetype-2*
	sys-libs/zlib"

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS README TODO
	prepgamesdirs
}
