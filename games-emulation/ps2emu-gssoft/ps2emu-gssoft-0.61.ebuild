# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-emulation/ps2emu-gssoft/ps2emu-gssoft-0.61.ebuild,v 1.4 2004/05/27 01:37:34 mr_bones_ Exp $

inherit games

DESCRIPTION="PSEmu2 GPU plugin"
HOMEPAGE="http://www.pcsx2.net/"
SRC_URI="http://www.pcsx2.net/download/0.5release/GSsoft-${PV}.tgz"

LICENSE="freedist"
SLOT="0"
KEYWORDS="x86 ~ppc"
IUSE=""

DEPEND="virtual/opengl
	virtual/x11
	=x11-libs/gtk+-1*"

S=${WORKDIR}/GSsoft

src_unpack() {
	unpack ${A}
	cd ${S}
	sed -i 's:-O3 -fomit-frame-pointer:$(OPTFLAGS):' ${S}/Src/Linux/Makefile
}

src_compile() {
	cd Src/Linux
	emake OPTFLAGS="${CFLAGS}" || die "building X"
}

src_install() {
	dodoc ReadMe.txt
	exeinto ${GAMES_LIBDIR}/ps2emu/plugins
	newexe Src/Linux/libGSsoftx.so libGSsoftx-${PV}.so
	prepgamesdirs
}
