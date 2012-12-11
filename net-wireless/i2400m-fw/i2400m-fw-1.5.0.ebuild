# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/i2400m-fw/i2400m-fw-1.5.0.ebuild,v 1.4 2012/12/11 10:01:16 ssuominen Exp $

EAPI=5
MY_PV=${PV%.0}

DESCRIPTION="Intel (R) WiMAX 5150/5350/6250 Firmware"
HOMEPAGE="http://www.linuxwimax.org"
SRC_URI="http://www.linuxwimax.org/Download?action=AttachFile&do=get&target=${P}.tar.bz2 -> ${P}.tar.bz2"

LICENSE="ipw3945"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="|| ( virtual/udev >=sys-apps/hotplug-20040923 )"

src_install() {
	insinto /lib/firmware
	for x in i2400m i6050; do
		doins ${x}-fw-usb-${MY_PV}.sbcf
	done
	dodoc README
}
