# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-action/twobowl-tactics/twobowl-tactics-0.5.ebuild,v 1.2 2004/03/09 14:54:09 dholm Exp $

inherit eutils games

S="${WORKDIR}/tbt/src"
DESCRIPTION="Tow Bowl Tactics is a game based on Games Workshop's Blood Bowl"
HOMEPAGE="http://www.towbowltactics.com/index_en.html"
SRC_URI="http://www.towbowltactics.com/download/tbt.${PV}.src.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc"
IUSE=""

RDEPEND="virtual/glibc
	>=dev-libs/libxml2-2.6.6
	>=media-libs/smpeg-0.4.4
	>=media-libs/sdl-net-1.2.5
	>=media-libs/sdl-image-1.2.3
	>=media-libs/sdl-mixer-1.2.5"
DEPEND="${RDEPEND}
	>=sys-apps/sed-4"

src_unpack() {
	local f

	unpack ${A}
	cd ${S}

	sed -i \
		-e "s/<language>0/<language>1/g" ../config.xml \
			|| die "sed config.xml failed"
	sed -i \
		-e "/^CFLAGS/ s:-O2 -g -fno-strength-reduce -Wall -W:${CFLAGS}:" \
	    -e "/^TBTHOME/ s:/.*:${GAMES_DATADIR}/tbt:" Makefile \
			|| die "sed Makefile failed"
	sed -i \
		-e "/tbt.ico/ s:\"\./:TBTHOME \"/:" Main.cpp \
			|| die "sed Main.cpp failed"
	sed -i \
		-e "s:TBTHOME \"/config.xml:\"${GAMES_SYSCONFDIR}/tbt/config.xml:g" \
			global.h || die "sed global,h failed"

	for f in `find ${S} -type f`
	do
		edos2unix ${f}
	done
}

src_install() {
	dogamesbin tbt || die "dogamesbin failed"
	dodir "${GAMES_DATADIR}/tbt"
	cp -r ../data ../tbt.ico "${D}${GAMES_DATADIR}/tbt" || die "cp failed"
	insinto "${GAMES_SYSCONFDIR}/tbt"
	doins ../config.xml || die "doins failed"
	prepgamesdirs
}
