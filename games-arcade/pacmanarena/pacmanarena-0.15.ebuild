# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-arcade/pacmanarena/pacmanarena-0.15.ebuild,v 1.13 2007/02/14 10:46:34 nyhm Exp $

inherit eutils games

DESCRIPTION="a Pacman clone in full 3D with a few surprises. Rockets, bombs and explosions abound."
HOMEPAGE="http://pacmanarena.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/pacman-arena-${PV}.tar.bz2
	mirror://sourceforge/${PN}/pacman-data-0.0.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 x86"
IUSE=""

RDEPEND="virtual/opengl
	virtual/glu
	media-libs/libsdl
	media-libs/sdl-mixer
	media-libs/sdl-net"
DEPEND="${RDEPEND}
	app-arch/unzip"

S=${WORKDIR}/pacman

src_unpack() {
	unpack pacman-arena-${PV}.tar.bz2
	cd "${S}"
	unpack pacman-data-0.0.zip

	sed -i \
		-e "/^CFLAGS/ s:pacman:${PN}:" \
		-e '1i CC=@CC@' \
		Makefile.in \
		|| die "sed Makefile.in failed"
	sed -i \
		-e '/CFLAGS/s:-g::' \
		configure \
		|| die "sed configure failed"
}

src_install() {
	newgamesbin pacman ${PN} || die "newgamesbin failed"
	insinto "${GAMES_DATADIR}"/${PN}
	doins -r gfx sfx || die "doins failed"
	newicon gfx/pacman_arena1.tga ${PN}.tga
	make_desktop_entry ${PN} "Pacman Arena" /usr/share/pixmaps/${PN}.tga
	dodoc README
	prepgamesdirs
}
