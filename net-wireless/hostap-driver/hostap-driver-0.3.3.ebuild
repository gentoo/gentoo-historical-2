# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/hostap-driver/hostap-driver-0.3.3.ebuild,v 1.1 2005/01/03 11:04:49 brix Exp $

inherit toolchain-funcs pcmcia kernel-mod eutils

DESCRIPTION="HostAP wireless drivers"
HOMEPAGE="http://hostap.epitest.fi"
SRC_URI="${SRC_URI} http://hostap.epitest.fi/releases/${P}.tar.gz"
LICENSE="GPL-2"

KEYWORDS="~x86 ~ppc"
IUSE=""
SLOT="0"

DEPEND="virtual/linux-sources
		sys-apps/sed"
RDEPEND=">=net-wireless/wireless-tools-25"

pkg_setup() {
	if ! kernel-mod_configoption_present NET_RADIO
	then
		eerror ""
		eerror "${P} requires support for Wireless LAN drivers (non-hamradio) &"
		eerror "Wireless Extensions (CONFIG_NET_RADIO) in the kernel."
		eerror ""
		die "CONFIG_NET_RADIO support not detected."
	fi

	kernel-mod_check_modules_supported
}

src_unpack() {
	unpack ${A}

	# set compiler
	sed -i -e "s:gcc:$(tc-getCC):" ${S}/Makefile

	# unpack the pcmcia-cs sources if needed
	pcmcia_src_unpack

	cd ${S}
	epatch ${FILESDIR}/${P}-firmware.patch

	# fix for new coreutils (#31801)
	sed -i "s:tail -1:tail -n 1:" ${S}/Makefile

	# set correct pcmcia path (PCMCIA_VERSION gets set from pcmcia_src_unpack)
	if [ -n "${PCMCIA_VERSION}" ]
	then
		sed -i "s:^\(PCMCIA_PATH\)=:\1=${PCMCIA_SOURCE_DIR}:" ${S}/Makefile
	fi

	# install to /lib/modules/${KV}/net
	sed -i "s:\$(MODPATH)/kernel/drivers/net/wireless:\$(MODPATH)/net:g" ${S}/Makefile
	sed -i "s:MODPATH_CS \:= \$(MODPATH)/pcmcia:MODPATH_CS \:= \$(MODPATH)/net:" ${S}/Makefile

	# let pkg_postinst() handle depmod
	sed -i "s:/sbin/depmod -ae; \\\:\\\:" ${S}/Makefile
	sed -i "s:/sbin/depmod -ae::" ${S}/Makefile

	if ! use pcmcia &> /dev/null
	then
		# remove install_pccard dependency from install_2.4 target
		sed -i "s#^\(install_2.4:.*\)install_pccard#\1#" ${S}/Makefile
	fi

	kernel-mod_getversion

	if [ ${KV_MINOR} -gt 5 ] && [ ${KV_PATCH} -gt 5 ]
	then
		sed -i "s:SUBDIRS=:M=:" ${S}/Makefile
	fi
}

src_compile() {
	pcmcia_configure

	set_arch_to_kernel
	emake all || die "emake failed"
	set_arch_to_portage
}

src_install() {
	# Makefile relies on existing /lib/modules/${KV}
	dodir /lib/modules/${KV}

	if use pcmcia &> /dev/null
	then
		# pcmcia configuration file is only installed if /etc/pcmcia exist
		dodir /etc/pcmcia
	else
		# make sure we do not install the hostap_cs module
		rm -rf ${S}/driver/modules/hostap_cs.*o
	fi

	set_arch_to_kernel
	emake DESTDIR=${D} install || die "emake install failed"
	set_arch_to_portage

	dodoc README ChangeLog
}

pkg_postinst() {
	einfo "Checking kernel module dependencies"
	test -r "${ROOT}/usr/src/linux/System.map" && \
		depmod -ae -F "${ROOT}/usr/src/linux/System.map" -b "${ROOT}" -r ${KV}

	if [ -e /etc/pcmcia/prism2.conf ]
	then
		einfo ""
		einfo "You may need to edit or remove /etc/pcmcia/prism2.conf"
		einfo "This is usually a result of conflicts with the"
		einfo "net-wireless/linux-wlan-ng drivers."
		einfo ""
	fi

	einfo ""
	einfo "Please notice that all ${PN} modules are now installed to"
	einfo "/lib/modules/${KV}/net/."
	einfo ""
	einfo "You may have to manually delete the old modules if upgrading from from"
	einfo "<=net-wireless/${PN}-0.2.4."
	einfo ""

	ewarn ""
	ewarn "Please note that this installation of HostAP contains support"
	ewarn "for downloading binary firmware images into the non-volatile"
	ewarn "(permanent) flash memory of wireless LAN cards."
	ewarn ""
	ewarn "Albeit being a great feature, this can lead to A DEAD CARD"
	ewarn "when inappropriately used (e.g. wrong firmware)."
	ewarn ""

}
