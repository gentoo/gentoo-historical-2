# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-strategy/scorched3d/scorched3d-43.ebuild,v 1.1 2010/04/04 20:46:55 mr_bones_ Exp $

EAPI=2
WX_GTK_VER=2.8
inherit autotools eutils wxwidgets games

DESCRIPTION="Multi-player tank battle in 3D (OpenGL)"
HOMEPAGE="http://www.scorched3d.co.uk/"
SRC_URI="mirror://sourceforge/${PN}/Scorched3D-${PV}-src.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="dedicated mysql"

DEPEND="media-libs/libsdl[video]
	media-libs/sdl-net
	media-libs/libpng
	media-libs/jpeg:0
	dev-libs/expat
	!dedicated? (
		virtual/opengl
		virtual/glu
		media-libs/libogg
		media-libs/libvorbis
		media-libs/openal
		media-libs/freealut
		x11-libs/wxGTK:2.8[X]
		media-libs/freetype:2
		sci-libs/fftw:3.0
	)
	mysql? ( virtual/mysql )"

S=${WORKDIR}/scorched

src_prepare() {
	epatch "${FILESDIR}"/${P}-*.patch
	eautoreconf
}

src_configure() {
	egamesconf \
		--disable-dependency-tracking \
		--with-fftw=/usr \
		--with-ogg=/usr \
		--with-vorbis=/usr \
		--datadir="${GAMES_DATADIR}/${PN}" \
		--with-docdir="/usr/share/doc/${PF}" \
		--with-wx-config="${WX_CONFIG}" \
		--without-pgsql \
		$(use_with mysql) \
		$(use_enable dedicated serveronly)
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	if ! use dedicated ; then
		newicon data/images/tank.bmp ${PN}.bmp
		make_desktop_entry ${PN} "Scorched 3D" /usr/share/pixmaps/${PN}.bmp
	fi
	prepgamesdirs
}
