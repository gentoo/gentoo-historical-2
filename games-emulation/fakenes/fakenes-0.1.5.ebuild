# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-emulation/fakenes/fakenes-0.1.5.ebuild,v 1.4 2004/06/24 22:26:30 agriffis Exp $

inherit eutils games

DESCRIPTION="portable, Open Source NES emulator which is written mostly in C"
HOMEPAGE="http://fakenes.sourceforge.net/"
SRC_URI="mirror://sourceforge/fakenes/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE=""

RDEPEND="media-libs/allegro
	sys-libs/zlib"
DEPEND="${RDEPEND}
	>=sys-apps/sed-4"

src_unpack() {
	unpack ${A}
	cd ${S}/src
	epatch ${FILESDIR}/${PV}-datadir.patch
	sed -i \
		-e "s:GENTOO_DIR:${GAMES_DATADIR}/${PN}:" main.c \
			|| die "sed main.c failed"
}

src_compile() {
	egamesconf || die
	emake -j1 || die "emake failed"
}

src_install() {
	dogamesbin src/fakenes || die "dogamesbin failed"
	insinto "${GAMES_DATADIR}/${PN}"
	doins src/support/fakenes.{dat,ico,rc}
	dodoc CHANGES README SOURCE SUPPORT
}
