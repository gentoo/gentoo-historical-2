# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-strategy/scorched3d/scorched3d-38.1.ebuild,v 1.4 2005/09/20 15:38:23 mr_bones_ Exp $

inherit wxwidgets games

DESCRIPTION="Multi-player tank battle in 3D (OpenGL)"
HOMEPAGE="http://www.scorched3d.co.uk/"
SRC_URI="mirror://sourceforge/scorched3d/Scorched3D-${PV}-src.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc x86"
IUSE="mysql"

DEPEND="virtual/opengl
	>=media-libs/libsdl-1.2.4
	>=media-libs/sdl-net-1.2.5
	>=media-libs/sdl-mixer-1.2.4
	=x11-libs/wxGTK-2.4*
	>=media-libs/freetype-2
	>=sys-libs/zlib-1.1.4
	mysql? ( dev-db/mysql )"

S=${WORKDIR}/scorched

pkg_setup() {
	need-wxwidgets gtk2 || die "You need to emerge wxGTK with USE='gtk2'"
	games_pkg_setup
}

src_compile() {
	need-wxwidgets gtk2 || die "You need to emerge wxGTK with USE='gtk2'"
	egamesconf \
		--disable-dependency-tracking \
		--exec_prefix="${GAMES_PREFIX}" \
		--datadir="${GAMES_DATADIR}/${PN}" \
		--with-docdir="/usr/share/doc/${PF}" \
		$(use_with mysql) \
		|| die
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	prepgamesdirs
}
