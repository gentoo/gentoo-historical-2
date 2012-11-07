# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-action/openastromenace/openastromenace-1.3.0.ebuild,v 1.1 2012/11/07 16:37:12 mr_bones_ Exp $

EAPI=4
inherit gnome2-utils cmake-utils eutils games

DESCRIPTION="Modern 3D space shooter with spaceship upgrade possibilities"
HOMEPAGE="http://sourceforge.net/projects/openastromenace/"
SRC_URI="mirror://sourceforge/openastromenace/${PN}-src-${PV}.tar.bz2"

LICENSE="GPL-3 UbuntuFontLicense-1.0 OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="virtual/opengl
	virtual/glu
	media-libs/libsdl[joystick,video,X]
	media-libs/openal
	media-libs/freealut
	media-libs/freetype:2
	media-libs/libogg
	media-libs/libvorbis
	x11-libs/libXinerama
	virtual/jpeg"

S=${WORKDIR}/AstroMenace

src_prepare() {
	# no messing with CXXFLAGS please.
	sed -i -e '/ADD_DEFINITIONS.*O3/d' CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs="-DDATADIR=${GAMES_DATADIR}/${PN}"

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile

	"${CMAKE_BUILD_DIR}"/AstroMenace --pack \
		--rawdata="${S}"/RAW_VFS_DATA \
		--dir=$(dirname "${CMAKE_BUILD_DIR}") || die
}

src_install() {
	newgamesbin "${CMAKE_BUILD_DIR}"/AstroMenace "${PN}"

	insinto "${GAMES_DATADIR}/${PN}"
	doins ../*.vfs

	newicon -s 128 astromenace_128.png ${PN}.png
	newicon -s 64 astromenace_64.png ${PN}.png

	dodoc ChangeLog.txt ReadMe.txt

	make_desktop_entry "${PN}" OpenAstroMenace
	prepgamesdirs
}

pkg_preinst() {
	games_pkg_preinst
	gnome2_icon_savelist
}

pkg_postinst() {
	games_pkg_postinst
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
