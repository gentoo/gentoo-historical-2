# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-arcade/frozen-bubble/frozen-bubble-1.0.0-r3.ebuild,v 1.4 2004/02/03 01:28:31 mr_bones_ Exp $

inherit games perl-module

NET_CLIENT_P=frozen-bubble-client-0.0.3
NET_SERVER_P=frozen-bubble-server-0.0.3
DESCRIPTION="A Puzzle Bubble clone written in perl (now with network support)"
HOMEPAGE="http://www.frozen-bubble.org/ http://chl.tuxfamily.org/frozen-bubble/"
SRC_URI="http://guillaume.cottenceau.free.fr/fb/${P}.tar.bz2
	http://chl.tuxfamily.org/frozen-bubble/${NET_CLIENT_P}.tar.bz2
	http://chl.tuxfamily.org/frozen-bubble/${NET_SERVER_P}.tar.bz2"

KEYWORDS="x86 ppc hppa amd64"
LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND="virtual/glibc
	>=sys-apps/sed-4
	>=dev-lang/perl-5.6.1
	>=media-libs/sdl-mixer-1.2.3
	>=dev-perl/sdl-perl-1.19.0"

src_unpack() {
	unpack ${A}

	sed -i \
		-e 's:INSTALLDIRS=.*:PREFIX=${D}/usr:' \
			${P}/c_stuff/Makefile \
				|| die 'sed c_stuff/Makefile failed'
}

src_compile() {
	make \
		OPTIMIZE="${CFLAGS}" \
		PREFIX=/usr \
		BINDIR=${GAMES_BINDIR} \
		DATADIR=${GAMES_DATADIR} \
		MANDIR=/usr/share/man \
			|| die "make failed"

	cd ${WORKDIR}/${NET_SERVER_P}
	./bootstrap.sh || die
	egamesconf || die
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
			|| die "make install failed"

	cd ${WORKDIR}/${NET_SERVER_P}
	make DESTDIR=${D} sbindir=${GAMES_BINDIR} install \
		|| die "make install failed"
	dodoc TODO
	newdoc README README.server

	prepgamesdirs
}
