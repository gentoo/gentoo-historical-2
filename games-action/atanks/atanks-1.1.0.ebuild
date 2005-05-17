# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-action/atanks/atanks-1.1.0.ebuild,v 1.10 2005/05/17 17:41:26 wolf31o2 Exp $

inherit eutils games

DESCRIPTION="Worms and Scorched Earth-like game"
HOMEPAGE="http://atanks.sourceforge.net/"
SRC_URI="mirror://sourceforge/atanks/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc"
IUSE=""

DEPEND="virtual/x11
	>=media-libs/allegro-4.0.3
	>=media-libs/allegttf-2.0"

S="${WORKDIR}/${PN}"

src_unpack() {
	unpack ${A}
	#apply both patches to compile with gcc-3.4.0 closing bug #49457
	epatch "${FILESDIR}/atanks-gcc34.patch"
	epatch "${FILESDIR}/${PV}-gentoo.patch"

	DATA_DIR="${GAMES_DATADIR}/${PN}"
	sed -i \
		-e "s:DATA_DIR=.*:DATA_DIR=\\\\\"${DATA_DIR}\\\\\":" \
		src/Makefile \
		|| die "sed src/Makefile failed"
}

src_install() {
	dogamesbin atanks || die "dogamesbin failed"
	dodir "${DATA_DIR}"
	cp {credits,gloat,instr,revenge}.txt *dat "${D}${DATA_DIR}" \
		|| die "cp failed"
	dodoc BUGS Changelog Help.txt tanks.txt README TODO
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	echo
	einfo "NOTE: If you had atanks version 0.9.8b or less installed"
	einfo "remove ~/.atanks-config to take advantage of new features."
}
