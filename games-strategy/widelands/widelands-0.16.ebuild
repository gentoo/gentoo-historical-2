# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-strategy/widelands/widelands-0.16.ebuild,v 1.3 2011/09/15 03:32:59 ssuominen Exp $

EAPI=3
inherit versionator cmake-utils games

MY_PV=build$(get_version_component_range 2)
MY_P=${PN}-${MY_PV}-src
DESCRIPTION="A game similar to Settlers 2"
HOMEPAGE="http://www.widelands.org/"
SRC_URI="http://launchpad.net/widelands/${MY_PV}/${MY_PV}/+download/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="dev-games/ggz-client-libs
	dev-lang/lua
	media-libs/sdl-image[jpeg,png]
	media-libs/sdl-mixer[vorbis]
	media-libs/sdl-gfx
	media-libs/sdl-net
	media-libs/glew
	media-libs/sdl-ttf"
DEPEND="${RDEPEND}
	dev-libs/boost"

S=${WORKDIR}/${MY_P}

CMAKE_BUILD_TYPE=Release
PREFIX=${GAMES_DATADIR}/${PN}

src_prepare() {
	sed -i \
		-e 's:__ppc__:__PPC__:' src/s2map.cc \
		|| die "sed s2map.cc failed"
	epatch \
		"${FILESDIR}"/${P}-goldmine.patch \
		"${FILESDIR}"/${P}-libpng15.patch
}

src_configure() {
	mycmakeargs+=(
		'-DWL_VERSION_STANDARD=true'
		"-DWL_INSTALL_PREFIX=${GAMES_PREFIX}"
		"-DWL_INSTALL_DATADIR=${GAMES_DATADIR}/${PN}"
		"-DWL_INSTALL_LOCALEDIR=${GAMES_DATADIR}/${PN}/locale"
		"-DWL_INSTALL_BINDIR=${GAMES_BINDIR}"
	)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install
	newicon pics/wl-ico-128.png ${PN}.png || die
	make_desktop_entry ${PN} Widelands
	dodoc ChangeLog CREDITS
	prepgamesdirs
}
