# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-strategy/glob2/glob2-0.8.2.ebuild,v 1.3 2004/03/10 23:02:21 mr_bones_ Exp $

inherit games

DESCRIPTION="state of the art Real Time Strategy (RTS) game"
HOMEPAGE="http://www.ysagoon.com/glob2/"
SRC_URI="http://www.ysagoon.com/glob2/data/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE="opengl"

DEPEND="virtual/glibc
	opengl? ( virtual/opengl )
	media-libs/libsdl
	media-libs/libpng
	media-libs/sdl-net
	media-libs/sdl-image
	media-libs/libvorbis
	=media-libs/freetype-2*
	sys-libs/zlib"

src_compile() {
	egamesconf `use_enable opengl` || die
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS ChangeLog NEWS README TODO
	prepgamesdirs
}
