# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/usbutils/usbutils-0.11-r3.ebuild,v 1.5 2003/11/17 22:12:46 weeve Exp $

inherit gnuconfig

# note: update these regularly from http://www.linux-usb.org/usb.ids
#       and upload to gentoo mirrors - <liquidx@gentoo.org>
USB_IDS_VER="20030906"

DESCRIPTION="USB enumeration utilities"
SRC_URI="http://usb.cs.tum.edu/download/usbutils/${P}.tar.gz
	mirror://gentoo/usb.ids-${USB_IDS_VER}.gz"
HOMEPAGE="http://usb.cs.tum.edu/"

KEYWORDS="x86 ~amd64 ~ppc sparc ~hppa ~alpha"
IUSE=""
SLOT="0"
LICENSE="GPL-2"

DEPEND="virtual/glibc"

src_unpack() {
	unpack ${A}
	use amd64 && gnuconfig_update
	use alpha && gnuconfig_update

	# replace usb.ids with an updated version
	mv ${WORKDIR}/usb.ids-${USB_IDS_VER} ${S}/usb.ids || die "unable to replace usb.ids"
}

src_compile() {
	# put usb.ids in same place as pci.ids (/usr/share/misc)
	econf \
		--datadir=/usr/share/misc || die "./configure failed"
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die

	# we don't need libusb.* from usbutils because it conflicts
	# with dev-libs/libusb
	rm -rf ${D}/usr/lib
	rm -rf ${D}/usr/include
}
