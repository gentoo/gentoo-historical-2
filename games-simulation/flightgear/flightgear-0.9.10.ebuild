# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-simulation/flightgear/flightgear-0.9.10.ebuild,v 1.3 2007/01/12 23:57:50 nyhm Exp $

inherit games

MY_PN=FlightGear
MY_P=${MY_PN}-${PV}
DESCRIPTION="Open Source Flight Simulator"
HOMEPAGE="http://www.flightgear.org/"
SRC_URI="mirror://flightgear/Source/${MY_P}.tar.gz
	mirror://flightgear/Shared/fgfs-base-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="sdl"

DEPEND="virtual/glut
	~dev-games/simgear-0.3.10
	>=media-libs/plib-1.8.4
	media-libs/freealut
	sdl? ( media-libs/libsdl )"

S=${WORKDIR}/${MY_P}

src_compile() {
	egamesconf \
		--disable-dependency-tracking \
		$(use_enable sdl) \
		|| die
	emake -j1 || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	insinto "${GAMES_DATADIR}"/${MY_PN}
	doins -r ../data/* || die "doins failed"
	dodoc AUTHORS ChangeLog NEWS README Thanks
	prepgamesdirs
}
