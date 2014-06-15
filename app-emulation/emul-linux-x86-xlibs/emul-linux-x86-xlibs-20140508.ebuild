# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/emul-linux-x86-xlibs/emul-linux-x86-xlibs-20140508.ebuild,v 1.2 2014/06/15 15:48:46 mgorny Exp $

EAPI=5
inherit emul-linux-x86

SRC_URI="!abi_x86_32? ( ${SRC_URI} )"
LICENSE="!abi_x86_32? ( FTL GPL-2 MIT ) abi_x86_32? ( metapackage )"
KEYWORDS="-* ~amd64"
IUSE="abi_x86_32 opengl"

DEPEND=""
RDEPEND="
	!abi_x86_32? (
		~app-emulation/emul-linux-x86-baselibs-${PV}
		x11-libs/libX11
		opengl? ( app-emulation/emul-linux-x86-opengl )

		!media-libs/fontconfig[abi_x86_32(-)]
		!media-libs/freetype[abi_x86_32(-)]
		!x11-libs/libICE[abi_x86_32(-)]
		!x11-libs/libpciaccess[abi_x86_32(-)]
		!x11-libs/libSM[abi_x86_32(-)]
		!x11-libs/libvdpau[abi_x86_32(-)]
		!x11-libs/libX11[abi_x86_32(-)]
		!x11-libs/libXau[abi_x86_32(-)]
		!x11-libs/libXaw[abi_x86_32(-)]
		!x11-libs/libxcb[abi_x86_32(-)]
		!x11-libs/libXcomposite[abi_x86_32(-)]
		!x11-libs/libXcursor[abi_x86_32(-)]
		!x11-libs/libXdamage[abi_x86_32(-)]
		!x11-libs/libXdmcp[abi_x86_32(-)]
		!x11-libs/libXext[abi_x86_32(-)]
		!x11-libs/libXfixes[abi_x86_32(-)]
		!x11-libs/libXft[abi_x86_32(-)]
		!x11-libs/libXi[abi_x86_32(-)]
		!x11-libs/libXinerama[abi_x86_32(-)]
		!x11-libs/libXmu[abi_x86_32(-)]
		!x11-libs/libXp[abi_x86_32(-)]
		!x11-libs/libXpm[abi_x86_32(-)]
		!x11-libs/libXrandr[abi_x86_32(-)]
		!x11-libs/libXrender[abi_x86_32(-)]
		!x11-libs/libXScrnSaver[abi_x86_32(-)]
		!x11-libs/libXt[abi_x86_32(-)]
		!x11-libs/libXtst[abi_x86_32(-)]
		!x11-libs/libXv[abi_x86_32(-)]
		!x11-libs/libXvMC[abi_x86_32(-)]
		!x11-libs/libXxf86dga[abi_x86_32(-)]
		!x11-libs/libXxf86vm[abi_x86_32(-)] )
	abi_x86_32? (
		media-libs/fontconfig[abi_x86_32(-)]
		media-libs/freetype[abi_x86_32(-)]
		x11-libs/libICE[abi_x86_32(-)]
		x11-libs/libpciaccess[abi_x86_32(-)]
		x11-libs/libSM[abi_x86_32(-)]
		x11-libs/libvdpau[abi_x86_32(-)]
		x11-libs/libX11[abi_x86_32(-)]
		x11-libs/libXau[abi_x86_32(-)]
		x11-libs/libXaw[abi_x86_32(-)]
		x11-libs/libxcb[abi_x86_32(-)]
		x11-libs/libXcomposite[abi_x86_32(-)]
		x11-libs/libXcursor[abi_x86_32(-)]
		x11-libs/libXdamage[abi_x86_32(-)]
		x11-libs/libXdmcp[abi_x86_32(-)]
		x11-libs/libXext[abi_x86_32(-)]
		x11-libs/libXfixes[abi_x86_32(-)]
		x11-libs/libXft[abi_x86_32(-)]
		x11-libs/libXi[abi_x86_32(-)]
		x11-libs/libXinerama[abi_x86_32(-)]
		x11-libs/libXmu[abi_x86_32(-)]
		x11-libs/libXp[abi_x86_32(-)]
		x11-libs/libXpm[abi_x86_32(-)]
		x11-libs/libXrandr[abi_x86_32(-)]
		x11-libs/libXrender[abi_x86_32(-)]
		x11-libs/libXScrnSaver[abi_x86_32(-)]
		x11-libs/libXt[abi_x86_32(-)]
		x11-libs/libXtst[abi_x86_32(-)]
		x11-libs/libXv[abi_x86_32(-)]
		x11-libs/libXvMC[abi_x86_32(-)]
		x11-libs/libXxf86dga[abi_x86_32(-)]
		x11-libs/libXxf86vm[abi_x86_32(-)] )"

src_prepare() {
	use abi_x86_32 || emul-linux-x86_src_prepare
}

src_install() {
	use abi_x86_32 || emul-linux-x86_src_install
}
