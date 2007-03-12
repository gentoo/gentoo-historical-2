# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-fps/nprquake-sdl/nprquake-sdl-1-r1.ebuild,v 1.11 2007/03/12 14:44:51 genone Exp $

inherit eutils games

DESCRIPTION="quake1 utilizing a hand drawn engine"
HOMEPAGE="http://www.cs.wisc.edu/graphics/Gallery/NPRQuake/ http://www.tempestgames.com/ryan/"
SRC_URI="http://www.tempestgames.com/ryan/downloads/NPRQuake-SDL.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE="cdinstall"

DEPEND="media-libs/libsdl"
RDEPEND="${DEPEND}
	cdinstall? ( games-fps/quake1-data )"

S=${WORKDIR}/NPRQuake-SDL

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${PV}-gentoo.patch
}

src_compile() {
	make \
		GENTOO_LIBDIR="${GAMES_LIBDIR}/${PN}" \
		GENTOO_DATADIR="${GAMES_DATADIR}/quake1" \
		OPTFLAGS="${CFLAGS}" \
		release \
		|| die
}

src_install() {
	dodoc README CHANGELOG
	newgamesbin NPRQuakeSrc/release*/bin/* nprquake-sdl \
		|| die "newgamesbin failed"
	dodir "${GAMES_LIBDIR}/${PN}"
	cp -r build/* "${D}/${GAMES_LIBDIR}/${PN}/" || die "cp failed"
	cd "${D}/${GAMES_LIBDIR}/${PN}"
	mv dr_default.so default.so
	ln -s sketch.so dr_default.so
	prepgamesdirs
}

pkg_postinst() {
	# same warning used in quake1 / quakeforge / nprquake-sdl
	games_pkg_postinst
	echo
	elog "Before you can play, you must make sure"
	elog "${PN} can find your Quake .pak files"
	elog
	elog "You have 2 choices to do this"
	elog "1 Copy pak*.pak files to ${GAMES_DATADIR}/quake1/id1"
	elog "2 Symlink pak*.pak files in ${GAMES_DATADIR}/quake1/id1"
	elog
	elog "Example:"
	elog "my pak*.pak files are in /mnt/secondary/Games/Quake/Id1/"
	elog "ln -s /mnt/secondary/Games/Quake/Id1/pak0.pak ${GAMES_DATADIR}/quake1/id1/pak0.pak"
	elog
	elog "You only need pak0.pak to play the demo version,"
	elog "the others are needed for registered version"
}
