# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/ipw2100/ipw2100-0.34.ebuild,v 1.1 2004/03/18 02:35:31 latexer Exp $

inherit kernel-mod eutils

MY_P=${P/ipw2100/ipw2100-full}
FW_VERSION="1.0"

DESCRIPTION="Driver for the Intel Centrino wireless chipset"

HOMEPAGE="http://ipw2100.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tgz
		mirror://gentoo/${PN}-fw-${FW_VERSION}.tgz"

LICENSE="GPL-2"
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

	unpack ${A}
	kernel-mod_getversion
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


	dodoc ISSUES README.ipw2100 DESIGN

	insinto /lib/modules/${KV}/net
	doins ipw2100.${KV_OBJ}
	doins av5100.${KV_OBJ}

	insinto /usr/lib/hotplug/firmware
	doins ${WORKDIR}/${PN}-${FW_VERSION}.fw
	doins ${WORKDIR}/LICENSE
}

pkg_postinst() {
	einfo "Checking kernel module dependancies"
	test -r "${ROOT}/usr/src/linux/System.map" && \
		depmod -ae -F "${ROOT}/usr/src/linux/System.map" -b "${ROOT}" -r ${KV}
}
