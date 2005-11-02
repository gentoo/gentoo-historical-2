# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/linux-wlan-ng-modules/linux-wlan-ng-modules-0.2.2-r1.ebuild,v 1.1 2005/11/02 20:44:02 betelgeuse Exp $

inherit eutils linux-mod

MY_P=${P/-modules/}
S=${WORKDIR}/${MY_P}

DESCRIPTION="Kernel modules for Prism2/2.5/3 based 802.11b wireless LAN products"
HOMEPAGE="http://linux-wlan.org"
SRC_URI="ftp://ftp.linux-wlan.org/pub/linux-wlan-ng/${MY_P}.tar.bz2"

LICENSE="MPL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~x86"

IUSE="debug pci pcmcia plx usb"

BUILD_TARGETS="default"
BUILD_PARAMS="WLAN_SRC=${S}/src"

pkg_setup() {
	# We have to put this to the global scope inside the function or it will be
	# reset between functions because the ebuild is sourced many times.

	MODULE_NAMES="p80211(net/wireless:${S}/src/p80211)"

	if use pci; then
		MODULE_NAMES="${MODULE_NAMES} prism2_pci(net/wireless:${S}/src/prism2/driver)"
	fi

	if use plx; then
		MODULE_NAMES="${MODULE_NAMES} prism2_plx(net/wireless:${S}/src/prism2/driver)"
	fi

	if use pcmcia; then
		MODULE_NAMES="${MODULE_NAMES} prism2_cs(net/wireless:${S}/src/prism2/driver)"
	fi

	if use usb; then
		MODULE_NAMES="${MODULE_NAMES} prism2_usb(net/wireless:${S}/src/prism2/driver)"
	fi

	linux-mod_pkg_setup
}

config_by_usevar() {
	local config=${3}
	[[ -z ${config} ]] && config=${S}/default.config

	if use ${2}; then
		echo "${1}=y" >> ${config}
	else
		echo "${1}=n" >> ${config}
	fi
}

src_unpack() {
	local config=${S}/default.config

	unpack ${A}

	cd ${S}
	epatch ${FILESDIR}/${MY_P}-module_param.patch
	epatch ${FILESDIR}/${PV}-kernel-2.6.14.patch

	cp ${S}/config.in ${config}

	echo "TARGET_ROOT_ON_HOST=${D}" >> ${config}
	echo "LINUX_SRC=${KERNEL_DIR}"  >> ${config}
	echo "FIRMWARE_DIR=/lib/firmware/" >> ${config}

	if use pcmcia && [[ -n "${PCMCIA_VERSION}" ]]; then
		echo "PCMCIA_SRC=${PCMCIA_SOURCE_DIR}" >> ${config}
	fi

	config_by_usevar PRISM2_USB usb
	config_by_usevar PRISM2_PCI pci
	config_by_usevar PRISM2_PLX plx
	config_by_usevar PRISM2_PCMCIA pcmcia
	config_by_usevar WLAN_DEBUG debug

	if kernel_is gt 2 4; then
		echo "KERN_25=y" >> ${config}
	fi

	sed -i -e "s:dep modules:modules:" ${S}/src/p80211/Makefile
}

src_compile() {
	set_arch_to_kernel
	emake default_config || die "emake default_config failed"
	set_arch_to_portage

	cd ${S}/src/mkmeta
	emake || die "emake mkmeta failed"

	linux-mod_src_compile
}
