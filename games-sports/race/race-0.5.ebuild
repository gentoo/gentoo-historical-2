# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-sports/race/race-0.5.ebuild,v 1.7 2004/06/28 17:25:29 jhuebel Exp $

inherit games gcc eutils

DESCRIPTION="OpenGL Racing Game"
HOMEPAGE="http://projectz.org/?id=70"
SRC_URI="ftp://users.freebsd.org.uk/pub/foobar2k/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc ~amd64"
IUSE=""

RDEPEND="virtual/opengl
	virtual/glu
	media-libs/libsdl
	media-libs/sdl-image
	media-libs/sdl-mixer"
DEPEND="${RDEPEND}
	>=sys-apps/sed-4"

src_unpack() {
	unpack ${A}
	cd ${S}/src
	epatch ${FILESDIR}/${PV}-gentoo.patch
	sed -i \
		-e "s:GENTOO_DATADIR:${GAMES_DATADIR}/${PN}:g" \
		-e "s:GENTOO_CONFDIR:${GAMES_SYSCONFDIR}:g" \
		*.c || die "sed failed"
	find ${S}/data/ -type d -name .xvpics | xargs rm -rf \{\} \;
}

src_compile() {
	emake CC="$(gcc-getCC) ${CFLAGS}" || die "emake failed"
}

src_install() {
	dogamesbin race || die "dogamesbin failed"
	insinto ${GAMES_SYSCONFDIR}
	newins config race.conf || die "newins failed"
	dodir ${GAMES_DATADIR}/${PN}
	cp -r data/* ${D}/${GAMES_DATADIR}/${PN}/ || die "cp failed"
	dodoc README
	prepgamesdirs
}
