# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/vmware-modules/vmware-modules-1.0.0.23-r1.ebuild,v 1.1 2009/05/16 07:33:20 ikelos Exp $

KEYWORDS="~amd64 ~x86"
VMWARE_VER="VME_V65" # THIS VALUE IS JUST A PLACE HOLDER

PATCH_VER="1"

inherit eutils vmware-mod

LICENSE="GPL-2"
IUSE=""

VMWARE_MODULE_LIST="vmmon vmnet vmblock vmci vsock"
SRC_URI="x86? ( http://dev.gentoo.org/~ikelos/devoverlay-distfiles/${PN}-${PVR}.x86.tar.bz2 )
		 amd64? ( http://dev.gentoo.org/~ikelos/devoverlay-distfiles/${PN}-${PVR}.amd64.tar.bz2 )"
VMWARE_MOD_DIR="${PN}-${PVR}"

src_unpack() {
	vmware-mod_src_unpack
	cd "${S}"
	epatch "${FILESDIR}/${PVR}-kernel-2.6.29.patch"
	epatch "${FILESDIR}/${PV}-makefile-kernel-dir.patch"
}
