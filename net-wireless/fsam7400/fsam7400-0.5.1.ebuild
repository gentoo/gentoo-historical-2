# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/fsam7400/fsam7400-0.5.1.ebuild,v 1.3 2009/09/18 16:28:23 tove Exp $

inherit linux-mod eutils

DESCRIPTION="Software killswitch for F-S Amilo laptops and compatible"
HOMEPAGE="http://zwobbl.homelinux.net"
SRC_URI="http://linux.zwobbl.de/pub/${P}.tgz
	http://linux.zwobbl.de/pub/${P}-2.6.19.1.patch.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"

IUSE=""
DEPEND=""
RDEPEND=""

BUILD_TARGETS="clean fsam7400.ko"
MODULE_NAMES="fsam7400(net/wireless)"
CONFIG_CHECK="WIRELESS_EXT"
ERROR_WIRELESS_EXT="${P} requires support for Wireless LAN drivers (non-harmradio) & Wireless Extensions (CONFIG_WIRELESS_EXT)."

pkg_setup() {
	kernel_is lt 2 6 && die "${P} needs a kernel >=2.6"
	linux-mod_pkg_setup
}

src_unpack() {
	unpack ${P}.tgz
	if kernel_is ge 2 6 19; then
		unpack ${P}-2.6.19.1.patch.gz
		epatch ${P}-2.6.19.1.patch
	fi
}

src_install() {
	linux-mod_src_install
	dodoc CHANGELOG README
}
