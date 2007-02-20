# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/madwifi-ng/madwifi-ng-0.9.2.1.ebuild,v 1.8 2007/02/20 12:12:40 genstef Exp $

inherit linux-mod

MY_P=${PN/-ng/}-${PV}
S=${WORKDIR}/${MY_P}

DESCRIPTION="Next Generation driver for Atheros based IEEE 802.11a/b/g wireless LAN cards"
HOMEPAGE="http://www.madwifi.org/"
SRC_URI="mirror://sourceforge/madwifi/madwifi-${PV}.tar.bz2"

LICENSE="atheros-hal
	|| ( BSD GPL-2 )"
SLOT="0"
KEYWORDS="amd64 ppc x86"

IUSE="amrr injection onoe"
DEPEND="app-arch/sharutils"
RDEPEND="!net-wireless/madwifi-old
		~net-wireless/madwifi-ng-tools-${PV:0:5}"

CONFIG_CHECK="CRYPTO NET_RADIO SYSCTL"
ERROR_CRYPTO="${P} requires Cryptographic API support (CONFIG_CRYPTO)."
ERROR_NET_RADIO="${P} requires support for Wireless LAN drivers (non-hamradio) & Wireless Extensions (CONFIG_NET_RADIO)."
ERROR_SYSCTL="${P} requires Sysctl support (CONFIG_SYSCTL)."
BUILD_TARGETS="all"
MODULESD_ATH_PCI_DOCS="README"

pkg_setup() {
	linux-mod_pkg_setup

	MODULE_NAMES="ath_hal(net:${S}/ath)
				wlan(net:${S}/net80211)
				wlan_acl(net:${S}/net80211)
				wlan_ccmp(net:${S}/net80211)
				wlan_tkip(net:${S}/net80211)
				wlan_wep(net:${S}/net80211)
				wlan_xauth(net:${S}/net80211)
				wlan_scan_sta(net:${S}/net80211)
				wlan_scan_ap(net:${S}/net80211)"

	BUILD_PARAMS="KERNELPATH=${KV_OUT_DIR}"

	if use amrr && use onoe; then
		eerror
		eerror "USE=\"amrr onoe\" is invalid, you can only specify one at a time."
		eerror
		die "USE=\"amrr onoe\" is invalid"
	fi

	if use amrr; then
		MODULE_NAMES="${MODULE_NAMES} ath_rate_amrr(net:${S}/ath_rate/amrr)"
		BUILD_PARAMS="${BUILD_PARAMS} ATH_RATE=ath_rate/amrr"
	elif use onoe; then
		MODULE_NAMES="${MODULE_NAMES} ath_rate_onoe(net:${S}/ath_rate/onoe)"
		BUILD_PARAMS="${BUILD_PARAMS} ATH_RATE=ath_rate/onoe"
	else
		MODULE_NAMES="${MODULE_NAMES} ath_rate_sample(net:${S}/ath_rate/sample)"
		BUILD_PARAMS="${BUILD_PARAMS} ATH_RATE=ath_rate/sample"
	fi

	MODULE_NAMES="${MODULE_NAMES} ath_pci(net:${S}/ath)"
}

src_unpack() {
	unpack ${A}

	cd ${S}
	epatch ${FILESDIR}/${PN}-0.9.2-{ath_intr,config.h,crypto_cipher_encrypt_one}.diff
	for dir in ath net80211 ath_rate/amrr ath_rate/onoe ath_rate/sample; do
		convert_to_m ${S}/${dir}/Makefile
	done

	epatch ${FILESDIR}/madwifi-ng-uudecode-gcda-fix.patch
	if use injection; then epatch ${FILESDIR}/madwifi-ng-r1886.patch; fi
#	epatch ${FILESDIR}/madwifi-association-fix.patch

	epatch ${FILESDIR}/${P}-linux-2.6.20.patch
	# Fix for madwifi bug 1016 and gentoo bug 157677.
	# Thanks got Jon Howell for the patch and reporting upstream.
	epatch ${FILESDIR}/${PN}-0.9.2-allow-cipher-none.diff
}

src_compile() {
	# assists in debugging
	emake KERNELPATH=${KV_OUT_DIR} info || die "emake info failed"

	# needed by the modules
	emake svnversion.h

	linux-mod_src_compile
}

src_install() {
	linux-mod_src_install

	dodoc README THANKS docs/users-guide.pdf docs/WEP-HOWTO.txt

	# install headers for use by
	# net-wireless/wpa_supplicant and net-wireless/hostapd
	insinto /usr/include/madwifi/include/
	doins include/*.h
	insinto /usr/include/madwifi/net80211
	doins net80211/*.h
}

pkg_postinst() {
	local moddir="${ROOT}/lib/modules/${KV_FULL}/net/"

	einfo "Removing old ath_rate modules"
	if use amrr; then
		[[ -f "${moddir}/ath_rate_onoe.${KV_OBJ}" ]] && rm "${moddir}/ath_rate_onoe.${KV_OBJ}"
		[[ -f "${moddir}/ath_rate_sample.${KV_OBJ}" ]] && rm "${moddir}/ath_rate_sample.${KV_OBJ}"
	elif use onoe; then
		[[ -f "${moddir}/ath_rate_amrr.${KV_OBJ}" ]] && rm "${moddir}/ath_rate_amrr.${KV_OBJ}"
		[[ -f "${moddir}/ath_rate_sample.${KV_OBJ}" ]] && rm "${moddir}/ath_rate_sample.${KV_OBJ}"
	else
		[[ -f "${moddir}/ath_rate_amrr.${KV_OBJ}" ]] && rm "${moddir}/ath_rate_amrr.${KV_OBJ}"
		[[ -f "${moddir}/ath_rate_onoe.${KV_OBJ}" ]] && rm "${moddir}/ath_rate_onoe.${KV_OBJ}"
	fi

	linux-mod_pkg_postinst

	einfo
	einfo "Interfaces (athX) are now automatically created upon loading the ath_pci"
	einfo "module."
	einfo
	einfo "The type of the created interface can be controlled through the 'autocreate'"
	einfo "module parameter."
	einfo
	einfo "If you use net-wireless/wpa_supplicant or net-wireless/hostapd with madwifi"
	einfo "you should remerge them now."
	einfo
}
