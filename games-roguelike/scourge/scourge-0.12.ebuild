# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-roguelike/scourge/scourge-0.12.ebuild,v 1.1 2006/01/02 03:01:44 mr_bones_ Exp $

inherit eutils games

DESCRIPTION="A rogue-like adventure game to eliminate pests"
HOMEPAGE="http://scourge.sf.net"
SRC_URI="mirror://sourceforge/scourge/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND="virtual/x11
	virtual/glu
	virtual/opengl
	>=media-libs/freetype-2
	>=media-libs/libsdl-1.2
	media-libs/sdl-net
	media-libs/sdl-mixer"

src_unpack() {
	unpack ${A}
	find "${S}/data" -type f -exec chmod a-x \{\} \;
}

src_compile() {
	egamesconf \
		--with-data-dir="${GAMES_DATADIR}/${PN}/data" \
		|| die
	emake || die "emake failed"
}

src_install() {
	dogamesbin src/scourge || die "dogamesbin failed"
	insinto "${GAMES_DATADIR}/${PN}"
	doins -r data/ || die "doins failed"
	dodoc AUTHORS README
	prepgamesdirs
}
