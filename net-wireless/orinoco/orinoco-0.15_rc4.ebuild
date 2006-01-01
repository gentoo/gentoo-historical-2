# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/orinoco/orinoco-0.15_rc4.ebuild,v 1.1 2006/01/01 23:17:03 brix Exp $

inherit linux-mod

MY_P=${P/_/}
S=${WORKDIR}/${MY_P}

DESCRIPTION="ORiNOCO IEEE 802.11 wireless LAN driver"
HOMEPAGE="http://www.nongnu.org/orinoco/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2 MPL-1.1"
SLOT="0"
KEYWORDS="~ppc ~x86"

IUSE="pcmcia"
RDEPEND="net-wireless/wireless-tools"

BUILD_TARGETS="all"
MODULESD_ORINOCO_DOCS="README.orinoco"

CONFIG_CHECK="~FW_LOADER !HERMES NET_RADIO ~PCI ~PCMCIA"
ERROR_HERMES="${P} requires Hermes chipset 802.11b support (Orinoco/Prism2/Symbol) (CONFIG_HERMES) to be DISABLED."
ERROR_NET_RADIO="${P} requires support for Wireless LAN drivers (non-hamradio) & Wireless Extensions (CONFIG_NET_RADIO)."
MODULESD_ORINOCO_NORTEL_ENABLED="no"
MODULESD_ORINOCO_PCI_ENABLED="no"
MODULESD_ORINOCO_PLX_ENABLED="no"
MODULESD_ORINOCO_TMD_ENABLED="no"

pkg_setup() {
	linux-mod_pkg_setup

	if kernel_is lt 2 6 11; then
		eerror
		eerror "${P} requires kernel 2.6.11 or above."
		eerror
		die "Kernel version too old."
	fi

	MODULE_NAMES="hermes(net/wireless:)
				  orinoco(net/wireless:)"

	if linux_chkconfig_present PCI; then
		MODULE_NAMES="${MODULE_NAMES}
					orinoco_nortel(net/wireless:)
					orinoco_pci(net/wireless:)
					orinoco_plx(net/wireless:)
					orinoco_tmd(net/wireless:)"
	fi

	if linux_chkconfig_present PPC_PMAC; then
		MODULE_NAMES="${MODULE_NAMES} airport(net/wireless:)"
	fi

	if use pcmcia && linux_chkconfig_present PCMCIA; then
		MODULE_NAMES="${MODULE_NAMES} orinoco_cs(net/wireless:)"

		if linux_chkconfig_present FW_LOADER; then
			MODULE_NAMES="${MODULE_NAMES} spectrum_cs(net/wireless:)"
		fi
	fi

	BUILD_PARAMS="KERNEL_PATH=${KV_OUT_DIR}"
}

src_compile() {
	linux-mod_src_compile

	if use pcmcia; then
		emake hermes.conf || die "emake hermes.conf failed"
	fi
}

src_install() {
	linux-mod_src_install

	dodoc NEWS

	if use pcmcia; then
		insinto /etc/pcmcia
		doins hermes.conf
	fi
}

pkg_postinst() {
	linux-mod_pkg_postinst

	if [[ -e ${ROOT}/lib/modules/${KV_FULL}/pcmcia/orinoco.${KV_OBJ} ]]; then
		ewarn
		ewarn "The modules from this package conflicts with the modules installed"
		ewarn "by the pcmcia-cs package. You will have to manually delete the"
		ewarn "duplicate modules from the"
		ewarn "  ${ROOT}lib/modules/${KV_FULL}/pcmcia/"
		ewarn "directory and manually run '/sbin/depmod -ae'"
		ewarn
	fi
}
