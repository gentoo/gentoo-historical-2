# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-arcade/xtux/xtux-20030306.ebuild,v 1.13 2008/09/03 02:10:03 mr_bones_ Exp $

inherit eutils games

DESCRIPTION="Multiplayer Gauntlet-style arcade game"
HOMEPAGE="http://xtux.sourceforge.net/"
SRC_URI="mirror://sourceforge/xtux/xtux-src-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

DEPEND="x11-libs/libXpm"

S=${WORKDIR}/${PN}

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i \
		-e "s:-g -Wall -O2:${CFLAGS}:" \
		src/{client,common,server}/Makefile \
		|| die "sed failed"
	sed -i \
		-e "s:./tux_serv:tux_serv:" \
		src/client/menu.c \
		|| die "sed failed"
	epatch "${FILESDIR}/${P}-particles.patch"
}

src_compile() {
	emake DATADIR="${GAMES_DATADIR}/xtux/data" || die "emake failed"
}

src_install () {
	dogamesbin xtux tux_serv || die "dogamesbin failed"
	insinto "${GAMES_DATADIR}/xtux"
	doins -r data/ || die "doins failed"
	dodoc AUTHORS CHANGELOG README README.GGZ doc/*
	newicon data/images/icon.xpm ${PN}.xpm
	make_desktop_entry xtux "Xtux" /usr/share/icons/${PN}.xpm
	prepgamesdirs
}
