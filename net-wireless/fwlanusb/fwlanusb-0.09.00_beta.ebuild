# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/fwlanusb/fwlanusb-0.09.00_beta.ebuild,v 1.3 2006/01/08 23:18:29 sbriesen Exp $

inherit eutils linux-mod

SUSEVER="10.0"
MY_PV="${PV//_/-}"

DESCRIPTION="driver for the AVM FRITZ!WLAN USB stick"
HOMEPAGE="http://www.avm.de"
SRC_URI="ftp://ftp.avm.de/cardware/fritzwlanusb.stick/linux/suse.${SUSEVER}/${PN}-suse${SUSEVER}-${MY_PV}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~x86 -*"
IUSE=""

S="${WORKDIR}/fritz"

DEPEND="virtual/linux-sources"

pkg_setup() {
	linux-mod_pkg_setup
	if ! kernel_is 2 6; then
		die "This package works only with 2.6 kernel!"
	fi
	if ! linux_chkconfig_present NET_WIRELESS; then
		die "For using this driver you need a kernel with enabled NET_WIRELESS support."
	fi
	BUILD_TARGETS="all"
	BUILD_PARAMS="LIBDIR=${S}/src"
	MODULE_NAMES="fwlanusb(net:${S}/src)"
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	# comment out obsolete macro
	sed -i "s:^\([[:space:]]*\)\(.*URB_ASYNC_UNLINK;.*\):\1/\* \2 \*/:g" src/buffers.c
	convert_to_m "src/Makefile"
}

src_install() {
	linux-mod_src_install
	dohtml Liesmich.html
}

pkg_postinst() {
	linux-mod_pkg_postinst
	einfo
	einfo "This is a *BETA* driver! Expect everything! ;-)"
	einfo
	einfo "AVM gives no support for this driver, but asks for"
	einfo "feedback. Email: linux@avm.de"
	einfo
	einfo "Current limitations:"
	einfo " - no WPA/WPA2 support"
	einfo " - no Stick & Surf function support"
	einfo " - creation of an ad hoc network isn't possible,"
	einfo "   you can only join an existing one."
	einfo
}
