# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-action/abuse_sdl/abuse_sdl-0.7.0-r2.ebuild,v 1.7 2005/06/15 17:30:25 wolf31o2 Exp $

inherit eutils games

DESCRIPTION="port of Abuse by Crack Dot Com"
HOMEPAGE="http://www.labyrinth.net.au/~trandor/abuse/"
SRC_URI="http://www.labyrinth.net.au/~trandor/abuse/files/${P}.tar.bz2
	http://www.labyrinth.net.au/~trandor/abuse/files/abuse_datafiles.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc ~sparc"
IUSE=""

RDEPEND="virtual/x11
	>=media-libs/libsdl-1.1.6"
DEPEND="${RDEPEND}
	>=sys-apps/sed-4"

DATA="${WORKDIR}/datafiles"

src_unpack() {
	cd ${WORKDIR}
	unpack ${P}.tar.bz2

	mkdir ${DATA}
	cd ${DATA}
	unpack abuse_datafiles.tar.gz

	# hard-coded path in the default config writer.
	cd ${S}
	sed -i \
		-e "s:/usr/local/share/games/abuse:${GAMES_DATADIR}/abuse:" \
			src/sdlport/setup.cpp || die "sed src/sdlport/setup.cpp failed"
}

src_compile() {
	egamesconf --datadir="${GAMES_DATADIR_BASE}" || die
	emake || die "emake failed"
}

src_install() {
	make DESTDIR=${D} install || die "make install failed"
	dodoc AUTHORS ChangeLog README TODO

	cd ${DATA}
	dodir ${GAMES_DATADIR}/abuse
	cp -R * ${D}/${GAMES_DATADIR}/abuse

	#fix for #10573 + #11475 ... stupid hippy bug
	cd ${D}/${GAMES_DATADIR}/abuse
	epatch ${FILESDIR}/stupid-fix.patch

	prepgamesdirs
}

pkg_postinst() {
	einfo "NOTE: If you had previous version of abuse installed"
	einfo "you may need to remove ~/.abuse for the game to work correctly."
	games_pkg_postinst
}
