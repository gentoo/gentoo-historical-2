# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/zd1211-firmware/zd1211-firmware-1.2.ebuild,v 1.1 2006/08/12 15:59:44 dsd Exp $

DESCRIPTION="Firmware for ZyDAS ZD1211 USB-WLAN devices supported by the zd1211rw driver"

HOMEPAGE="http://zd1211.ath.cx/wiki/DriverRewrite"
SRC_URI="mirror://sourceforge/zd1211/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""
DEPEND=">=sys-apps/hotplug-20040923"

S="${WORKDIR}/${PN}"

src_install() {
	insinto /lib/firmware/zd1211
	doins zd1211_ub zd1211_ur zd1211_uphr
	doins zd1211b_ub zd1211b_ur zd1211b_uphr

	dodoc README
}
