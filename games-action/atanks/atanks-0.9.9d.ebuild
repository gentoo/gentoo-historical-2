# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-action/atanks/atanks-0.9.9d.ebuild,v 1.2 2004/02/05 23:21:16 mr_bones_ Exp $

inherit games

DATA_DIR="${GAMES_DATADIR}/${PN}"
S="${WORKDIR}/${PN}"
DESCRIPTION="Worms and Scorched Earth-like game"
HOMEPAGE="http://atanks.sourceforge.net/"
SRC_URI="mirror://sourceforge/atanks/${P}.tar.gz"
LICENSE="GPL-2"
KEYWORDS="x86"
SLOT="0"
IUSE=""

DEPEND="virtual/x11
	>=sys-apps/sed-4
	>=media-libs/allegro-4.0.3
	>=media-libs/allegttf-2.0"

src_unpack() {
	unpack ${A}
	cd ${S}

	sed -i \
		-e "s:DATA_DIR=.*:DATA_DIR=\\\\\"${DATA_DIR}\\\\\":" src/Makefile || \
			die "sed src/Makefile failed"
}

src_install() {
	dogamesbin atanks
	dodir /usr/share/games/atanks
	cp ${S}/*dat ${D}${DATA_DIR}

	dodoc Changelog INSTRUCTIONS README TODO readme.linux tanks.txt
	prepgamesdirs
}

pkg_postinst() {
	einfo "NOTE: If you had atanks version 0.9.8b or less installed"
	einfo "remove ~/.atanks-config to take advantage of new features."
	games_pkg_postinst
}
