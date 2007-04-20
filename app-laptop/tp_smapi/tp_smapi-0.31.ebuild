# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-laptop/tp_smapi/tp_smapi-0.31.ebuild,v 1.1 2007/04/20 13:18:01 chainsaw Exp $

inherit linux-mod

DESCRIPTION="IBM ThinkPad SMAPI BIOS driver"
HOMEPAGE="http://tpctl.sourceforge.net/"
SRC_URI="mirror://sourceforge/tpctl/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"

IUSE="hdaps"

RESTRICT="userpriv"

# We need dmideode if the kernel does not support DMI_DEV_TYPE_OEM_STRING
# in dmi.h
DEPEND="sys-apps/dmidecode"

pkg_setup() {
	linux-mod_pkg_setup

	if kernel_is lt 2 6 15; then
		eerror
		eerror "${P} requires Linux kernel 2.6.15 or above."
		eerror
		die "Unsupported kernel version"
	fi

	MODULE_NAMES="thinkpad_ec(extra:) tp_smapi(extra:)"
	BUILD_PARAMS="KSRC=${KV_DIR} KBUILD=${KV_DIR}"
	BUILD_TARGETS="default"

	if use hdaps; then
		MODULE_NAMES="${MODULE_NAMES} hdaps(extra:)"
		BUILD_PARAMS="${BUILD_PARAMS} HDAPS=1"
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	# Ug, sudo in a Makefile
	sed -i 's,sudo ,,' Makefile
}

src_install() {
	linux-mod_src_install

	dodoc CHANGES README
}
