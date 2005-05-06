# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-arcade/holotz-castle/holotz-castle-1.3.6.ebuild,v 1.1 2005/05/06 23:27:54 vapier Exp $

inherit eutils games

DESCRIPTION="2d platform jump'n'run game"
HOMEPAGE="http://www.mainreactor.net/holotzcastle/en/index_en.html"
SRC_URI="http://www.mainreactor.net/holotzcastle/download/${P}-src.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="virtual/opengl
	media-libs/sdl-mixer
	media-libs/libsdl
	media-libs/sdl-ttf
	media-libs/sdl-image"

S=${WORKDIR}/${P}-src

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-build.patch
}

src_compile() {
	for d in JLib src ; do
		emake -C ${d} CPU_OPTS="${CXXFLAGS}" || die "${d} failed"
	done
}

src_install() {
	dogamesbin holotz-castle holotz-castle-editor || die "dobin"
	insinto "${GAMES_DATADIR}"/${PN}/game
	doins -r HCedHome/* res/* || die "doins"
	dodoc MANUAL*.txt
	doman doc/*.6
	prepgamesdirs
}
