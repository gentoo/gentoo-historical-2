# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-emulation/ps2emu-spu2null/ps2emu-spu2null-0.21.ebuild,v 1.5 2004/06/24 22:33:29 agriffis Exp $

inherit games

DESCRIPTION="PSEmu2 NULL Sound plugin"
HOMEPAGE="http://www.pcsx2.net/"
SRC_URI="http://www.pcsx2.net/download/0.5release/SPU2null${PV}.zip"

LICENSE="freedist"
SLOT="0"
KEYWORDS="x86 ~ppc"
IUSE=""

DEPEND="=x11-libs/gtk+-1*"

S=${WORKDIR}/SPU2null

src_unpack() {
	unpack ${A}
	sed -i 's:-O2 -fomit-frame-pointer:$(OPTFLAGS):' ${S}/Src/Makefile
}

src_compile() {
	cd Src
	emake OPTFLAGS="${CFLAGS}" || die
}

src_install() {
	dodoc ReadMe.txt
	exeinto ${GAMES_LIBDIR}/ps2emu/plugins
	newexe Src/libSPU2null.so libSPU2null-${PV}.so
	prepgamesdirs
}
