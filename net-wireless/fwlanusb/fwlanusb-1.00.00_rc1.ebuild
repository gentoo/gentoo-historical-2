# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/fwlanusb/fwlanusb-1.00.00_rc1.ebuild,v 1.1 2007/05/21 21:54:05 sbriesen Exp $

inherit eutils linux-mod

SUSEVER="10.2"
MY_PV="${PV//_/-}"

DESCRIPTION="Driver for the AVM FRITZ!WLAN USB stick"
HOMEPAGE="http://www.avm.de"
SRC_URI="ftp://ftp.avm.de/cardware/fritzwlanusb.stick/linux/suse.${SUSEVER}/${PN}-suse${SUSEVER/.}-${MY_PV}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

S="${WORKDIR}/fritz"

DEPEND="virtual/linux-sources"

pkg_setup() {
	linux-mod_pkg_setup
	if ! kernel_is 2 6; then
		die "This package works only with 2.6 kernel!"
	fi
	if ! linux_chkconfig_present NET_WIRELESS; then
		die "You need a kernel with enabled NET_WIRELESS support!"
	fi
	BUILD_TARGETS="all"
	BUILD_PARAMS="KDIR=${KV_DIR} LIBDIR=${S}/src"
	MODULE_NAMES="fwlanusb(net:${S}/src)"
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	convert_to_m "src/Makefile"
}

src_install() {
	linux-mod_src_install
	dohtml *.html
}

pkg_postinst() {
	linux-mod_pkg_postinst
	elog
	elog "This is a *BETA* driver! Expect everything! ;-)"
	elog
	elog "Current limitations:"
	elog " - no Stick & Surf function support"
	elog " - creation of an ad hoc network isn't possible,"
	elog "   you can only join an existing one."
	elog
}
