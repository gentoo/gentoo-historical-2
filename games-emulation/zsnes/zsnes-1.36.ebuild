# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-emulation/zsnes/zsnes-1.36.ebuild,v 1.6 2004/06/24 22:38:07 agriffis Exp $

inherit games

DESCRIPTION="SNES (Super Nintendo) emulator that uses x86 assembly"
HOMEPAGE="http://www.zsnes.com/"
SRC_URI="mirror://sourceforge/zsnes/zsnes${PV//./}src.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* x86"
IUSE="opengl"

RDEPEND="opengl? ( virtual/opengl )
	>=media-libs/libsdl-1.2.0
	sys-libs/zlib
	media-libs/libpng"
DEPEND="${RDEPEND}
	>=dev-lang/nasm-0.98"

src_compile() {
	# Do NOT introduce custom ${CFLAGS}.
	# Current choices are the optimal ones
	cd src
	egamesconf `use_with opengl` || die
	emake || die "emake failed"
}

src_install() {
	dogamesbin src/zsnes
	newman src/linux/zsnes.1 zsnes.6
	dodoc *.txt linux/*
	prepgamesdirs
}
