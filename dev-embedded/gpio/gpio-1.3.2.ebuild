# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-embedded/gpio/gpio-1.3.2.ebuild,v 1.3 2005/01/01 17:52:45 eradicator Exp $

inherit linux-mod

DESCRIPTION="Soekris net4501/4801 GPIO and error LED driver"
HOMEPAGE="http://soekris.hejl.de/"
SRC_URI="http://soekris.hejl.de/gpio-${PV}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""
RDEPEND=""
DEPEND="virtual/libc"

MODULE_NAMES="gpio(kernel/drivers:) writelcd(kernel/drivers:)"
BUILD_PARAMS="KERNELDIR=${KV_DIR}"
BUILD_TARGETS="all"

src_unpack() {
	unpack ${A}
	cd ${S} || die
	chmod -x *
}

src_install() {
	linux-mod_src_install

	# Setup gpio device nods.
	#cat /proc/devices |sed -e "/\([0-9]*\).*gpio.*/!D;s/\([0-9]*\).*/\1/"
	local major=254
	dodir /dev
	mknod ${D}/dev/gpio0 c $major 0
	mknod ${D}/dev/gpio1 c $major 1
	mknod ${D}/dev/gpio254 c $major 254
	chmod 664 ${D}/dev/gpio[0-1]
}
