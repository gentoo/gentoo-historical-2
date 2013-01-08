# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-strategy/seven-kingdoms/seven-kingdoms-2.14.4.ebuild,v 1.1 2013/01/08 00:00:49 pinkbyte Exp $

EAPI=5

AUTOTOOLS_AUTORECONF=1
AUTOTOOLS_IN_SOURCE_BUILD=1

inherit autotools-utils games

MY_PN="7kaa"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Seven Kingdoms: Ancient Adversaries"
HOMEPAGE="http://7kfans.com/"
SRC_URI="mirror://sourceforge/skfans/${MY_PN}-source-${PV}.tar.bz2
	http://dev.gentoo.org/~pinkbyte/distfiles/${MY_PN}.png"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="media-libs/libsdl[X,video]
	media-libs/sdl-net
	media-libs/openal"
RDEPEND="${DEPEND}"
PDEPEND="games-strategy/seven-kingdoms-data"

S="${WORKDIR}/${MY_P}"

DOCS=( README )

src_configure() {
	# In current state debugging works only on Windows :-/
	egamesconf \
		--disable-debug \
		--without-directx \
		--without-wine \
		--program-suffix=".bin" \
		--datadir="${GAMES_DATADIR}/${MY_PN}"
}

src_install() {
	autotools-utils_src_install

	doicon "${DISTDIR}/${MY_PN}.png"
	games_make_wrapper "${MY_PN}" "${GAMES_BINDIR}/${MY_PN}.bin" "${GAMES_DATADIR}/${MY_PN}"
	make_desktop_entry "${MY_PN}" "Seven Kingdoms: Ancient Adversaries" "${MY_PN}" "Game;StrategyGame"

	prepgamesdirs
}
