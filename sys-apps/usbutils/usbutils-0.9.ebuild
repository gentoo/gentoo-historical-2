# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/sys-apps/usbutils/usbutils-0.9.ebuild,v 1.3 2002/07/21 19:33:25 gerk Exp $

S=${WORKDIR}/${P}
DESCRIPTION="USB enumeration utilities"
SRC_URI="http://usb.cs.tum.edu/download/usbutils/${P}.tar.gz"
HOMEPAGE="http://usb.cs.tum.edu/"
KEYWORDS="x86 ppc"
SLOT="0"
LICENSE="GPL-2"

DEPEND="virtual/glibc"

src_compile() {
	# put usb.ids in same place as pci.ids (/usr/share/misc)
	./configure \
		--host=${CHOST} \
		--prefix=/usr \
		--infodir=/usr/share/info \
		--mandir=/usr/share/man \
		--datadir=/usr/share/misc || die "./configure failed"
	
	emake || die
}

src_install () {
	make DESTDIR=${D} install || die
}
