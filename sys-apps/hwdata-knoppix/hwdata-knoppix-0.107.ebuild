# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/hwdata-knoppix/hwdata-knoppix-0.107.ebuild,v 1.10 2004/09/03 21:03:23 pvdabeel Exp $

inherit eutils

MY_PV=${PV}-4
DESCRIPTION="Data for the hwsetup program"
SRC_URI="http://developer.linuxtag.net/knoppix/sources/${PN}_${MY_PV}.tar.gz"
HOMEPAGE="http://www.knopper.net"

IUSE="opengl livecd"
KEYWORDS="x86 ppc amd64 alpha"
SLOT="0"
LICENSE="GPL-2"

DEPEND=""
RDEPEND=""

src_unpack() {
	unpack ${A}
	use livecd && use opengl && epatch ${FILESDIR}/${P}-binary_drivers.patch
}

src_install() {
	dodoc debian/README.build debian/changelog debian/control debian/copyright debian/mergepcitable
	dodir /usr/X11R6/lib/X11/
	ln -s ../../../share/hwdata/Cards ${D}/usr/X11R6/lib/X11/Cards
	insinto /usr/share/hwdata
	doins debian/pcitable-knoppix CardMonitorCombos Cards MonitorsDB pci.ids pcitable upgradelist usb.ids
}
