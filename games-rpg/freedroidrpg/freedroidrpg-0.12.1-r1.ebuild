# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-rpg/freedroidrpg/freedroidrpg-0.12.1-r1.ebuild,v 1.3 2009/08/29 18:10:39 nixnut Exp $

EAPI=2
inherit autotools eutils games

DESCRIPTION="A modification of the classical Freedroid engine into an RPG"
HOMEPAGE="http://freedroid.sourceforge.net/"
SRC_URI="mirror://sourceforge/freedroid/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc x86"
IUSE="opengl"

RDEPEND="media-libs/libsdl
	dev-lang/lua
	media-libs/jpeg
	media-libs/libpng
	media-libs/sdl-image[jpeg,png]
	media-libs/sdl-net
	media-libs/sdl-mixer[vorbis]
	media-libs/sdl-gfx
	media-libs/libogg
	media-libs/libvorbis
	x11-libs/libX11
	opengl? ( virtual/opengl )"
DEPEND="${RDEPEND}
	x11-libs/libXt
	dev-lang/python"

src_prepare() {
	rm -rf lua src/SDL_rotozoom*
	epatch "${FILESDIR}"/${P}-syslibs.patch

	# No need for executable game resources
	find sound graphics -type f -exec chmod -c a-x '{}' +
	eautoreconf
}

src_configure() {
	egamesconf \
		--disable-dependency-tracking \
		--disable-fastmath \
		$(use_enable opengl)
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	rm -f "${D}/${GAMES_BINDIR}/"{croppy,pngtoico,gluem}
	newicon win32/w32icon2_64x64.png ${PN}.png
	make_desktop_entry freedroidRPG "Freedroid RPG"
	prepgamesdirs
}
