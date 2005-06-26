# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/rtl8180/rtl8180-0.21-r1.ebuild,v 1.1 2005/06/26 17:12:55 genstef Exp $

inherit linux-mod eutils

DESCRIPTION="Driver for the rtl8180 wireless chipset"
HOMEPAGE="http://rtl8180-sa2400.sourceforge.net"
SRC_URI="mirror://sourceforge/rtl8180-sa2400/${P}.tar.gz"
LICENSE="GPL-2"

KEYWORDS="~x86 ~ppc"
IUSE=""
DEPEND="net-wireless/wireless-tools"

MODULE_NAMES="r8180(net:) ieee80211-r8180(net:)
	ieee80211_crypt-r8180(net:) ieee80211_crypt_wep-r8180(net:)"
CONFIG_CHECK="NET_RADIO CRYPTO CRYPTO_ARC4 CRC32"
BUILD_TARGETS="all"

pkg_setup() {
	linux-mod_pkg_setup
	BUILD_PARAMS="KSRC=${KV_DIR}"
}

src_unpack() {
	unpack ${A}
	cd ${S}
	kernel_is ge 2 6 12 && epatch ${FILESDIR}/rtl8180-pci_name.patch
	epatch ${FILESDIR}/rtl8180_gcc4_fix.patch
}

src_install() {
	linux-mod_src_install

	dodoc AUTHORS CHANGES INSTALL README README.adhoc
}
