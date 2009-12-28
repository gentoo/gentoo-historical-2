# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-strategy/warzone2100/warzone2100-2.2.4.ebuild,v 1.3 2009/12/28 14:18:55 rich0 Exp $

EAPI=2
inherit versionator games

MY_PV=$(get_version_component_range -2)
DESCRIPTION="3D real-time strategy game"
HOMEPAGE="http://wz2100.net/"
SRC_URI="mirror://sourceforge/warzone2100/${P}.tar.gz
	videos? ( http://download.gna.org/warzone/videos/sequences-${MY_PV}.wz )"

LICENSE="GPL-2 CCPL-Attribution-ShareAlike-3.0 public-domain"
SLOT="0"
KEYWORDS="amd64 ~ppc ~x86"
# upstream requested debug support
IUSE="debug nls videos"

RDEPEND="dev-db/sqlite:3
	>=dev-games/physfs-2[zip]
	dev-libs/popt
	media-libs/libogg
	media-libs/libpng
	media-libs/libsdl[opengl,video]
	media-libs/libtheora
	media-libs/libvorbis
	media-libs/openal
	media-libs/sdl-net
	media-libs/quesoglc
	virtual/glu
	virtual/opengl
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	app-arch/zip
	dev-util/pkgconfig
	nls? ( sys-devel/gettext )"
RDEPEND="${RDEPEND}
	media-fonts/dejavu"

src_configure() {
	egamesconf \
		--disable-dependency-tracking \
		--docdir=/usr/share/doc/${PF} \
		--localedir=/usr/share/locale \
		--with-distributor="Gentoo ${PF}" \
		--with-icondir=/usr/share/pixmaps \
		--with-applicationdir=/usr/share/applications \
		$(use_enable debug debug relaxed) \
		$(use_enable nls)
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	rm -f "${D}"/usr/share/doc/${PF}/COPYING*
	if use videos ; then
		insinto "${GAMES_DATADIR}"/${PN}
		newins "${DISTDIR}"/sequences-${MY_PV}.wz sequences.wz \
			|| die "newins failed"
	fi
	prepgamesdirs
}
