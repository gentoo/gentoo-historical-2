# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-emulation/pcsx2/pcsx2-0.41.ebuild,v 1.2 2003/09/09 23:33:23 msterret Exp $

inherit games eutils

DESCRIPTION="Playstation2 emulator"
HOMEPAGE="http://www.pcsx2.net/"
SRC_URI="http://www.pcsx2.net/download/0.4release/Pcsx2Src-${PV}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"

RDEPEND="virtual/x11
	=x11-libs/gtk+-1*
	|| (
		games-emulation/ps2emu-cddvdlinuz
		games-emulation/ps2emu-cdvdiso
	)
	games-emulation/ps2emu-gssoft
	games-emulation/ps2emu-padxwin
	games-emulation/ps2emu-spu2null"
DEPEND="${RDEPEND}
	dev-lang/nasm"

S=${WORKDIR}/Pcsx2Src

src_unpack() {
	unpack ${A}
	epatch ${FILESDIR}/${PV}-time-renames.patch
}

src_compile() {
	cd Linux
	emake OPTIMIZE="${CFLAGS}" || die
}

src_install() {
	newgamesbin Linux/pcsx2 pcsx2.bin
	dogamesbin ${FILESDIR}/pcsx2
	dodir ${GAMES_LIBDIR}/ps2emu/Langs
	cp -r Intl/Langs/* ${D}/${GAMES_LIBDIR}/ps2emu/Langs/
	dodoc Docs/*.txt
	prepgamesdirs
}
