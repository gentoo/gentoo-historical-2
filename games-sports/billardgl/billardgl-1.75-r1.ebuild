# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-sports/billardgl/billardgl-1.75-r1.ebuild,v 1.4 2004/06/24 23:24:08 agriffis Exp $

inherit games

DESCRIPTION="A OpenGL billards game"
HOMEPAGE="http://www.billardgl.de/"
SRC_URI="mirror://sourceforge/billardgl/BillardGL-${PV}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="amd64 x86 ppc"
SLOT="0"
IUSE=""

RDEPEND="virtual/x11
	virtual/opengl
	virtual/glu
	virtual/glut"
DEPEND="${RDEPEND}
	>=sys-apps/sed-4"

S="${WORKDIR}/BillardGL-${PV}/src"

src_unpack() {
	unpack ${A}
	cd ${S}
	sed -i \
		-e "s:/usr/share/BillardGL/:${GAMES_DATADIR}/BillardGL/:" Namen.h || \
			die "sed Namen.h failed"
	sed -i \
		-e "/^CFLAGS/ s:-pipe -Wall -W:${CFLAGS}:" \
		-e "/^CXXFLAGS/ s:-pipe -Wall -W:${CXXFLAGS}:" Makefile \
			|| die "sed Makefile failed"
}

src_install() {
	dogamesbin BillardGL || die "dogamesbin failed"
	dodir ${GAMES_DATADIR}/BillardGL
	cp -r lang/ Texturen/ "${D}/${GAMES_DATADIR}/BillardGL" || die "cp failed"
	dodoc README
	prepgamesdirs
}
