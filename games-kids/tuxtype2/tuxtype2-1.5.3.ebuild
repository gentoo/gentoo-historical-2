# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-kids/tuxtype2/tuxtype2-1.5.3.ebuild,v 1.3 2005/01/14 22:23:44 luckyduck Exp $

inherit games

DESCRIPTION="Typing tutorial with lots of eye-candy"
HOMEPAGE="http://www.geekcomix.com/dm/tuxtype/"
SRC_URI="mirror://sourceforge/tuxtype/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="ppc sparc x86 ~amd64"
IUSE=""

DEPEND=">=media-libs/libsdl-1.2
	>=media-libs/sdl-mixer-1.2
	>=media-libs/sdl-image-1.2
	>=media-libs/sdl-ttf-2.0.6"

src_unpack() {
	unpack ${A}
	cd ${S}
	sed -i \
		-e 's:$(prefix)/share:'${GAMES_DATADIR}':g' \
		-e 's:$(prefix)/doc/$(PACKAGE):/usr/share/doc/'${PF}':g' \
		$(find -name Makefile.in) || die "fixing Makefile paths"
	sed -i \
		-e 's:/usr/share:'${GAMES_DATADIR}':' \
		tuxtype/theme.c || die "fixing src paths"
}

src_install() {
	make DESTDIR="${D}" install || die
	prepalldocs
	prepgamesdirs
}
