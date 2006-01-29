# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-arcade/openmortal/openmortal-0.7.ebuild,v 1.5 2006/01/29 00:00:27 joshuabaergen Exp $

inherit games

DESCRIPTION="A spoof of the famous Mortal Combat game"
HOMEPAGE="http://apocalypse.rulez.org/~upi/Mortal/"
SRC_URI="mirror://sourceforge/openmortal/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND="media-libs/libsdl
	media-libs/sdl-image
	media-libs/sdl-mixer
	media-libs/sdl-ttf
	media-libs/sdl-net
	>=media-libs/freetype-2.1.0
	dev-lang/perl"

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS ChangeLog TODO README
	prepgamesdirs
}
