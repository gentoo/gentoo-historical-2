# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-action/supertuxkart/supertuxkart-0.8.ebuild,v 1.4 2012/12/13 16:12:24 mr_bones_ Exp $

EAPI=2
inherit cmake-utils eutils games

DESCRIPTION="A kart racing game starring Tux, the linux penguin (TuxKart fork)"
HOMEPAGE="http://supertuxkart.sourceforge.net/"
SRC_URI="mirror://sourceforge/supertuxkart/SuperTuxKart/${PV}/${P}-src.tar.bz2
	mirror://gentoo/${PN}.png"

LICENSE="GPL-3 CCPL-Attribution-ShareAlike-3.0 CCPL-Attribution-2.0 public-domain ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="debug"

# don't unbundle irrlicht and bullet
# both are modified and system versions will break the game
# http://sourceforge.net/tracker/?func=detail&aid=3454889&group_id=74339&atid=540679

# VERSION BUMP NOTICE: enet might be needed for supertuxkart-0.9
RDEPEND="dev-libs/fribidi
	media-libs/freeglut
	media-libs/libpng:0
	media-libs/libvorbis
	media-libs/openal
	net-misc/curl
	sys-libs/zlib
	virtual/glu
	virtual/jpeg
	virtual/libintl
	virtual/opengl
	x11-libs/libX11
	x11-libs/libXxf86vm"
DEPEND="${RDEPEND}
	sys-devel/gettext
	virtual/pkgconfig"

S=${WORKDIR}/SuperTuxKart-${PV}

src_prepare() {
	epatch "${FILESDIR}"/${P}-{gentoo,fribidi,irrlicht}.patch
	sed -i \
		-e '/Encoding/d' \
		data/supertuxkart_desktop.template || die

	# inconsistent handling of debug definition
	# avoid using Debug build type
	if use debug ; then
		sed -i \
			-e 's/add_definitions(-DNDEBUG)/add_definitions(-DDEBUG)/' \
			CMakeLists.txt || die
	fi
}

src_configure() {
	local mycmakeargs=(
		-DSTK_INSTALL_BINARY_DIR="${GAMES_BINDIR}"
		-DSTK_INSTALL_DATA_DIR="${GAMES_DATADIR}"/${PN}
	)

	cmake-utils_src_configure
}

src_compile() {
	# build bundled irrlicht
	NDEBUG=1 emake -C lib/irrlicht/source/Irrlicht

	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install
	doicon "${DISTDIR}"/${PN}.png
	make_desktop_entry ${PN} SuperTuxKart
	dodoc AUTHORS ChangeLog README TODO
	prepgamesdirs
}
