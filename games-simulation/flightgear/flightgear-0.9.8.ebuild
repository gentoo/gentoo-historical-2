# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-simulation/flightgear/flightgear-0.9.8.ebuild,v 1.5 2005/04/21 19:13:21 hansmi Exp $

inherit flag-o-matic games

MY_PN=FlightGear
MY_P=${MY_PN}-${PV}
S="${WORKDIR}/${MY_P}"
DESCRIPTION="Open Source Flight Simulator"
HOMEPAGE="http://www.flightgear.org/"
SRC_URI="mirror://flightgear/Source/${MY_P}.tar.gz
	mirror://flightgear/Shared/fgfs-base-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc ~sparc x86"
IUSE=""

RDEPEND="virtual/glut
	~dev-games/simgear-0.3.8
	>=media-libs/plib-1.8.4"
DEPEND="${RDEPEND}
	>=sys-apps/sed-4"

src_unpack() {
	unpack ${A}
	cd ${S}
	mv ../data ./data
}

src_compile() {
	use hppa && replace-flags -march=2.0 -march=1.0
	egamesconf \
		--with-multiplayer \
		--with-network-olk \
		--with-threads \
		--with-x || die
	emake -j1 || die "emake failed"
}

src_install() {
	egamesinstall || die

	dodir "${GAMES_DATADIR}/${MY_PN}"
	cp -a data/* "${D}/${GAMES_DATADIR}/${MY_PN}" || die "cp failed"

	dodoc README* ChangeLog AUTHORS NEWS Thanks

	prepgamesdirs
}
