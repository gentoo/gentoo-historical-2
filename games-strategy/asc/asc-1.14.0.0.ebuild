# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-strategy/asc/asc-1.14.0.0.ebuild,v 1.1 2004/03/06 19:01:42 mr_bones_ Exp $

inherit games

DESCRIPTION="turn based strategy game designed in the tradition of the Battle Isle series"
HOMEPAGE="http://www.asc-hq.org/"
SRC_URI="mirror://sourceforge/asc-hq/asc-source-${PV}.tar.gz
	http://www.asc-hq.org/frontiers.mp3
	http://www.asc-hq.org/time_to_strike.mp3
	http://www.asc-hq.org/machine_wars.mp3"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE=""

RDEPEND="virtual/glibc
	app-arch/bzip2
	>=media-libs/libsdl-1.1.3
	media-libs/sdl-image
	media-libs/sdl-mixer
	>=media-libs/sdlmm-0.1.8
	>=dev-libs/libsigc++-1.2
	>=media-libs/paragui-1.0.1"
DEPEND="${RDEPEND}
	app-arch/zip"

src_unpack() {
	unpack ${A}
	cd ${S}/data/music && cp ${DISTDIR}/*mp3 . || die "cp music failed"
}

src_compile() {
	# Added --disable-paraguitest for bugs 26402 and 4488
	egamesconf \
		--datadir=${GAMES_DATADIR_BASE} \
		--disable-dependency-tracking \
		--disable-paraguitest \
			|| die
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS ChangeLog README TODO
	dohtml -r doc/*
	prepgamesdirs
}
