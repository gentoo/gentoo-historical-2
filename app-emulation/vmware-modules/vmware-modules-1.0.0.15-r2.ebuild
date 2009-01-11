# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/vmware-modules/vmware-modules-1.0.0.15-r2.ebuild,v 1.2 2009/01/11 22:08:54 maekke Exp $

KEYWORDS="amd64 x86"
VMWARE_VER="VME_S1B1"
IUSE=""

inherit vmware-mod

pkg_setup() {
	if kernel_is lt 2 6 25; then
		CONFIG_CHECK=""
	else
		CONFIG_CHECK="UNUSED_SYMBOLS"
	fi
	vmware-mod_pkg_setup
}
