# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-fps/wmquake/wmquake-1.1.ebuild,v 1.2 2004/05/27 03:17:53 mr_bones_ Exp $

inherit games

DESCRIPTION="Quake1 in a dockapp window"
SRC_URI="http://www.ne.jp/asahi/linux/timecop/software/${P}.tar.bz2"
HOMEPAGE="http://www.ne.jp/asahi/linux/timecop/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="virtual/x11"

src_unpack() {
	unpack ${A}
	cd ${S}
	sed -i \
		-e "s:CFLAGS = .*:CFLAGS = ${CFLAGS}:" Makefile \
		|| die "sed Makefile failed"
}

src_compile() {
	emake || die "emake failed"
}

src_install() {
	exeinto "${GAMES_LIBDIR}/wmquake"
	doexe wmquake
	games_make_wrapper wmquake "${GAMES_LIBDIR}/wmquake/wmquake" "${GAMES_DATADIR}/quake-data/"
	dodoc README*
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	echo
	einfo "Before you can play, you must make sure"
	einfo "wmquake can find your Quake .pak files"
	echo
	einfo "You have 2 choices to do this"
	einfo "1 Copy pak*.pak files to ${GAMES_DATADIR}/quake-data/id1"
	einfo "2 Symlink pak*.pak files in ${GAMES_DATADIR}/quake-data/id1"
	echo
	einfo "Example:"
	einfo "my pak*.pak files are in /mnt/secondary/Games/Quake/Id1/"
	einfo "ln -s /mnt/secondary/Games/Quake/Id1/pak0.pak ${GAMES_DATADIR}/quake-data/id1/pak0.pak"
	echo
	einfo "You only need pak0.pak to play the demo version,"
	einfo "the others are needed for registered version"
}
