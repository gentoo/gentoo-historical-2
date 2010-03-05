# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-board/holdingnuts/holdingnuts-0.0.5-r1.ebuild,v 1.1 2010/03/05 21:30:29 mr_bones_ Exp $

EAPI=2
inherit eutils cmake-utils games

DESCRIPTION="An open source poker client and server"
HOMEPAGE="http://www.holdingnuts.net/"
SRC_URI="http://downloads.sourceforge.net/${PN}/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="alsa debug dedicated"

RDEPEND="
	!dedicated? (
		x11-libs/qt-core:4
		x11-libs/qt-gui:4
		alsa? ( >=media-libs/libsdl-1.2.10[alsa] )
	)"

DEPEND="${RDEPEND}
	>=dev-util/cmake-2.6.3"

PATCHES=( "${FILESDIR}"/${P}-wheel.patch ) # upstream patch (bug #307901)

src_configure() {
	local mycmakeargs="$(cmake-utils_use_enable alsa AUDIO)
		$(cmake-utils_use_enable !dedicated CLIENT)
		$(cmake-utils_use_enable debug DEBUG)"

	mycmakeargs="${mycmakeargs}
		-DCMAKE_INSTALL_PREFIX=${GAMES_PREFIX}
		-DCMAKE_DATA_PATH=${GAMES_DATADIR}"

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	if ! use dedicated ; then
		domenu ${PN}.desktop
		doicon ${PN}.png
		doman docs/${PN}.6
	fi

	dodoc ChangeLog docs/protocol_spec.txt
	doman docs/${PN}-server.6

	prepgamesdirs
}
