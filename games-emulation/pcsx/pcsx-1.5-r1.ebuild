# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-emulation/pcsx/pcsx-1.5-r1.ebuild,v 1.6 2005/01/09 10:49:20 swegener Exp $

inherit games eutils

S=${WORKDIR}/PcsxSrc-${PV}
DESCRIPTION="Playstation emulator"
HOMEPAGE="http://www.pcsx.net/"
SRC_URI="http://www.pcsx.net/downloads/PcsxSrc-${PV}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 -ppc"
IUSE="opengl"

DEPEND="sys-libs/zlib
	>=sys-apps/sed-4
	app-arch/unzip
	x11-libs/gtk+
	gnome-base/libglade"
RDEPEND="games-emulation/psemu-cdr
	games-emulation/psemu-cdriso
	games-emulation/psemu-padxwin
	games-emulation/psemu-padjoy
	games-emulation/psemu-peopsspu
	|| (
		opengl? ( x86? ( games-emulation/psemu-gpupetemesagl ) )
		games-emulation/psemu-peopssoftgpu
	)"

src_unpack() {
	unpack PcsxSrc-${PV}.tgz
	cd ${S}

	edos2unix `find -regex '.*\.[ch]'`

	epatch ${FILESDIR}/${PV}-gentoo.patch
	sed -i \
		-e "s:Plugin/:${GAMES_LIBDIR}/psemu/plugins/:" \
		-e "s:Bios/:${GAMES_LIBDIR}/psemu/bios/:" \
		-e 's:Pcsx.cfg:~/.pcsx/config:' \
		Linux/LnxMain.c \
		|| die "sed LnxMain.c failed"
	if [ "${ARCH}" = "ppc" ]; then
		sed -i \
			-e "s:^CPU\ =.*:CPU = powerpc:" Linux/Makefile \
			|| die "sed Linux/Makefile failed"
		sed -i \
			-e "s:__LINUX__:__i386__:g" Gte.c \
			|| die "sed Gte.c failed"
	fi
}

src_compile() {
	cd Linux
	econf || die "econf failed"
	emake OPTIMIZE="${CFLAGS}" || die "emake failed"
}

src_install() {
	newgamesbin Linux/pcsx pcsx.bin
	dogamesbin ${FILESDIR}/pcsx
	insinto ${GAMES_DATADIR}/${PN}
	doins Linux/.pixmaps/*
	dodoc Docs/*
	prepgamesdirs
}
