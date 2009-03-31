# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-action/btanks/btanks-0.8.7686.ebuild,v 1.5 2009/03/31 13:22:15 darkside Exp $

EAPI=2
inherit eutils games

DESCRIPTION="Fast 2D tank arcade game with multiplayer and split-screen modes"
HOMEPAGE="http://btanks.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE=""

RDEPEND=">=dev-lang/lua-5.1
	media-libs/libsdl
	media-libs/libvorbis
	virtual/opengl
	dev-libs/expat
	sys-libs/zlib
	media-libs/smpeg
	media-libs/sdl-image[jpeg,png]"
DEPEND="${RDEPEND}
	dev-util/scons
	dev-util/pkgconfig"

PATCHES=( "${FILESDIR}"/${P}-scons-blows.patch )

src_compile() {
	local sconsopts=$(echo "${MAKEOPTS}" | sed -e "s/.*\(-j[0-9]\+\).*/\1/")

	scons \
		${sconsopts} \
		prefix="${GAMES_PREFIX}" \
		lib_dir="$(games_get_libdir)"/${PN} \
		plugins_dir="$(games_get_libdir)"/${PN} \
		resources_dir="${GAMES_DATADIR}"/${PN} \
		|| die "scons failed"
}

src_install() {
	dogamesbin build/release/engine/btanks || die "dogamesbin failed"
	newgamesbin build/release/editor/bted btanksed || die "newgamesbin failed"
	exeinto "$(games_get_libdir)"/${PN}
	doexe build/release/*/*.so || die "doexe failed"
	insinto "${GAMES_DATADIR}"/${PN}
	doins -r data || die "doins failed"
	newicon engine/src/bt.xpm ${PN}.xpm
	make_desktop_entry ${PN} "Battle Tanks"
	dodoc ChangeLog *.txt
	prepgamesdirs
}
