# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-strategy/asc/asc-1.16.0.0.ebuild,v 1.1 2005/05/04 01:40:39 mr_bones_ Exp $

inherit games

DESCRIPTION="turn based strategy game designed in the tradition of the Battle Isle series"
HOMEPAGE="http://www.asc-hq.org/"
SRC_URI="mirror://sourceforge/asc-hq/asc-source-${PV}.tar.bz2
	http://www.asc-hq.org/frontiers.mp3
	http://www.asc-hq.org/time_to_strike.mp3
	http://www.asc-hq.org/machine_wars.mp3"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND="virtual/libc
	app-arch/bzip2
	media-libs/jpeg
	>=media-libs/libsdl-1.2.2
	media-libs/sdl-image
	media-libs/sdl-mixer
	=dev-libs/libsigc++-1.2*"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_unpack() {
	unpack ${A}
	cp "${DISTDIR}/"*mp3 "${S}/data/music" || die "cp music failed"
}

src_compile() {
	# Added --disable-paraguitest for bugs 26402 and 4488
	# Added --disable-paragui for bug 61154 since it's not really used much
	# and the case is well documented at http://www.asc-hq.org/
	egamesconf \
		--disable-dependency-tracking \
		--disable-paraguitest \
		--disable-paragui \
		--datadir="${GAMES_DATADIR_BASE}" \
		|| die
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS ChangeLog README TODO
	dohtml -r doc/*
	prepgamesdirs
}
