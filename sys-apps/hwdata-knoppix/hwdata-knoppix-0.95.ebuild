# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/hwdata-knoppix/hwdata-knoppix-0.95.ebuild,v 1.6 2005/01/02 23:23:42 ciaranm Exp $

MY_PV=${PV}-1
DESCRIPTION="data hwsetup program"
SRC_URI="http://developer.linuxtag.net/knoppix/sources/${PN}_${MY_PV}.tar.gz"
HOMEPAGE="http://www.knopper.net"

IUSE=""
KEYWORDS="x86 ppc"
SLOT="0"
LICENSE="GPL-2"

DEPEND=""
RDEPEND=""

src_unpack() {
	unpack ${A}
}

src_install() {
	dodoc debian/README.build debian/changelog debian/control debian/copyright debian/mergepcitable
	dodir /usr/X11R6/lib/X11/
	ln -s ../../../share/hwdata/Cards ${D}/usr/X11R6/lib/X11/Cards
	insinto /usr/share/hwdata
	doins debian/pcitable-knoppix CardMonitorCombos Cards MonitorsDB pci.ids pcitable upgradelist usb.ids
}
