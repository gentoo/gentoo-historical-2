# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-kids/tuxtype/tuxtype-1.0.3.ebuild,v 1.4 2004/07/01 11:19:25 eradicator Exp $

inherit games

DESCRIPTION="Typing tutorial with lots of eye-candy"
SRC_URI="mirror://sourceforge/tuxtype/${P}.tar.bz2"
HOMEPAGE="http://www.geekcomix.com/dm/tuxtype/"

KEYWORDS="x86 ppc"
LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND="virtual/libc
	>=media-libs/libsdl-1.2
	>=media-libs/sdl-mixer-1.2
	>=media-libs/sdl-image-1.2"

src_compile() {
	egamesconf --with-gnu-ld --disable-sdltest
	emake || die
}

src_install() {
	egamesinstall

	# now fix where the installer put everything
	cd ${D}/${GAMES_PREFIX}/${PN}
	dohtml *.html ; rm -f *.html
	docfiles="`find -type f -maxdepth 1`"
	dodoc ${docfiles} ; rm -f ${docfiles}
	dodir ${GAMES_DATADIR}/${PN}
	mv * ${D}/${GAMES_DATADIR}/${PN}
	cd ${D}/${GAMES_PREFIX}
	rm -rf ${PN}

	prepgamesdirs
}
