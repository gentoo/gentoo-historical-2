# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/memtest86/memtest86-3.0-r1.ebuild,v 1.11 2004/07/15 01:49:00 agriffis Exp $

inherit mount-boot

DESCRIPTION="A stand alone memory test for x86 computers"
SRC_URI="http://www.memtest86.com/${P}.tar.gz"
HOMEPAGE="http://www.memtest86.com/"
KEYWORDS="x86 -amd64 -ppc -sparc "
IUSE=""
LICENSE="GPL-2"
SLOT="0"

DEPEND="virtual/libc"

src_install() {
	dodir /boot/memtest86
	cp precomp.bin ${D}/boot/memtest86/memtest.bin
	dodoc README README.build-process
}

pkg_postinst() {
	einfo
	einfo "*** memtest.bin has been installed in /boot/memtest86."
	einfo "*** You may wish to update your bootloader configs,"
	einfo "*** by adding these lines.  For grub:"
	einfo "***   > title=Memtest86"
	einfo "***   > root (hd0,0)"
	einfo "***   > kernel /boot/memtest86/memtest.bin"
	einfo "*** For lilo:"
	einfo "***   > image  = /boot/memtest86/memtest.bin"
	einfo "***   > label  = Memtest86"
	einfo
}
