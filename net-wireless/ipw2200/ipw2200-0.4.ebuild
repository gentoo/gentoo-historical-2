# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/ipw2200/ipw2200-0.4.ebuild,v 1.1 2004/08/17 02:54:46 jbms Exp $

inherit kernel-mod eutils

FW_VERSION="1.2"

DESCRIPTION="Driver for the Intel PRO/Wireless 2200BG miniPCI adapter"

HOMEPAGE="http://ipw2200.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tgz
		mirror://gentoo/${PN}-fw-${FW_VERSION}.tgz"

LICENSE="GPL-2 ipw2200-fw"
SLOT="0"
KEYWORDS="~x86"

IUSE=""
DEPEND=""
RDEPEND=">=sys-apps/hotplug-20030805-r2"

src_unpack() {
	if ! egrep "^CONFIG_FW_LOADER=[ym]" ${ROOT}/usr/src/linux/.config >/dev/null
	then
		eerror ""
		eerror "New versions of ${PN} require firmware loader support from"
		eerror "your kernel. This can be found in Device Drivers --> Generic"
		eerror "Driver Support on 2.6 or in Library Routines on 2.4 kernels."
		die "Firmware loading support not detected."
	fi

	if ! egrep "^CONFIG_CRC32=[ym]" ${ROOT}/usr/src/linux/.config >/dev/null
	then
		eerror ""
		eerror "New versions of ${PN} require support for CRC32 in"
		eerror "your kernel. This can be found in Library Routines in"
		eerror "kernel configs."
		die "CRC32 function support not detected."
	fi

	unpack ${A}
	kernel-mod_getversion

	if [ ${KV_MINOR} -gt 5 ] && [ ${KV_PATCH} -gt 5 ]
	then
		sed -i 's:SUBDIRS=:M=:g' ${S}/Makefile
	fi
}

src_compile() {
	unset ARCH
	emake KSRC=${ROOT}/usr/src/linux all || die
}

src_install() {
	if [ ${KV_MINOR} -gt 4 ]
	then
		KV_OBJ="ko"
	else
		KV_OBJ="o"
	fi

	dodoc ISSUES README.${PN} CHANGES

	insinto /lib/modules/${KV}/net
	doins ieee80211_crypt.${KV_OBJ} ieee80211_crypt_wep.${KV_OBJ} \
		ieee80211.${KV_OBJ} ${PN}.${KV_OBJ}

	insinto /usr/lib/hotplug/firmware
	doins ${WORKDIR}/${PN}_boot.fw
	doins ${WORKDIR}/${PN}_bss.fw
	doins ${WORKDIR}/${PN}_ibss.fw
	doins ${WORKDIR}/${PN}_ucode.fw
}

pkg_postinst() {
	einfo "Checking kernel module dependancies"
	test -r "${ROOT}/usr/src/linux/System.map" && \
		depmod -ae -F "${ROOT}/usr/src/linux/System.map" -b "${ROOT}" -r ${KV}
}
