# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-emulation/vgba/vgba-2.1.ebuild,v 1.4 2004/06/24 22:36:51 agriffis Exp $

inherit games

DESCRIPTION="Gameboy Advance (GBA) emulator for Linux"
HOMEPAGE="http://www.komkon.org/fms/VGBA/"
SRC_URI="http://fms.komkon.org/VGBA/VGBA${PV/.}-Linux-80x86-bin.tar.Z"

LICENSE="VGBA"
SLOT="0"
KEYWORDS="-* x86"
IUSE=""

RDEPEND="virtual/x11"

S="${WORKDIR}"

src_install() {
	into "${GAMES_PREFIX_OPT}"
	dobin vgba || die "dobin failed"
	dohtml VGBA.html
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	echo
	ewarn "You must run X in 16bit color for the emu to work"
	echo
}
