# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/i2c/i2c-2.6.5-r1.ebuild,v 1.4 2003/09/08 08:02:45 msterret Exp $

S="${WORKDIR}/${P}"
DESCRIPTION="I2C Bus support"
SRC_URI="http://www2.lm-sensors.nu/~lm78/archive/${P}.tar.gz"
HOMEPAGE="http://www2.lm-sensors.nu/~lm78"
KEYWORDS="x86 amd64 ppc"
LICENSE="GPL-2"

SLOT="0"

DEPEND="virtual/linux-sources"

src_compile ()  {
	emake LINUX_INCLUDE_DIR=/usr/include/linux clean all || \
	die "i2c requires the source of a compatible kernel\nversion installed in /usr/src/linux\nand kernel i2c *disabled* or *enabled as a module*"
}

src_install () {
	emake LINUX_INCLUDE_DIR=/usr/include/linux DESTDIR=${D} PREFIX=/usr MANDIR=/usr/share/man install || die
	dodoc CHANGES INSTALL README
}

pkg_postinst() {
	[ -x /usr/sbin/update-modules ] && /usr/sbin/update-modules

	einfo "*****************************************************************"
	einfo
	einfo "i2c package installed ..."
	einfo
	einfo "IMPORTANT ... if you are installing this package you need to either"
	einfo "IMPORTANT ... *disable* kernel i2c support or *enable it as a module*"
	einfo
	einfo "*****************************************************************"
}


