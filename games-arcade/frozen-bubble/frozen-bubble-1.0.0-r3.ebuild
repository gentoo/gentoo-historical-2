# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-arcade/frozen-bubble/frozen-bubble-1.0.0-r3.ebuild,v 1.9 2004/04/29 19:26:15 agriffis Exp $

inherit perl-module games

NET_CLIENT_P=frozen-bubble-client-0.0.3
NET_SERVER_P=frozen-bubble-server-0.0.3
DESCRIPTION="A Puzzle Bubble clone written in perl (now with network support)"
HOMEPAGE="http://www.frozen-bubble.org/ http://chl.tuxfamily.org/frozen-bubble/"
SRC_URI="http://guillaume.cottenceau.free.fr/fb/${P}.tar.bz2
	http://chl.tuxfamily.org/frozen-bubble/${NET_CLIENT_P}.tar.bz2
	http://chl.tuxfamily.org/frozen-bubble/${NET_SERVER_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc hppa amd64 ~alpha"
IUSE=""

RDEPEND="virtual/glibc
	>=dev-lang/perl-5.6.1
	>=media-libs/sdl-mixer-1.2.3
	>=dev-perl/sdl-perl-1.19.0"
DEPEND="${RDEPEND}
	>=sys-apps/sed-4
	sys-devel/autoconf"

src_unpack() {
	unpack ${A}
	cd ${S}
	sed -i \
		-e 's:INSTALLDIRS=.*:PREFIX=${D}/usr:' \
		c_stuff/Makefile \
		|| die 'sed c_stuff/Makefile failed'
	cd ${WORKDIR}/${NET_SERVER_P}
	sed -i '/^dnl AM_CONFIG_HEADER/s:dnl ::' configure.in
	env WANT_AUTOCONF=2.5 ./bootstrap.sh || die "bootstrap failed"
	echo '#include "config.h"' >> fb_serv.h
}

src_compile() {
	make \
		OPTIMIZE="${CFLAGS}" \
		PREFIX=/usr \
		BINDIR=${GAMES_BINDIR} \
		DATADIR=${GAMES_DATADIR} \
		MANDIR=/usr/share/man \
		|| die "make game failed"

	cd ${WORKDIR}/${NET_SERVER_P}
	egamesconf || die
	make || die "make server failed"
}

src_install() {
	make \
		PREFIX=${D}/usr \
		BINDIR=${D}/${GAMES_BINDIR} \
		DATADIR=${D}/${GAMES_DATADIR} \
		MANDIR=${D}/usr/share/man \
		install \
		|| die "make install failed"
	dosed /usr/games/bin/frozen-bubble
	dodoc AUTHORS CHANGES README

	cd ${WORKDIR}/${NET_CLIENT_P}
	make \
		PREFIX=${D}/usr \
		BINDIR=${D}/${GAMES_BINDIR} \
		DATADIR=${D}/${GAMES_DATADIR} \
		MANDIR=${D}/usr/share/man \
		install \
		|| die "make install client failed"

	cd ${WORKDIR}/${NET_SERVER_P}
	make \
		DESTDIR=${D} \
		sbindir=${GAMES_BINDIR} \
		install \
		|| die "make install server failed"
	dodoc TODO
	newdoc README README.server

	prepgamesdirs
}
