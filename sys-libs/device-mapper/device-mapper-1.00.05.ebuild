# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/device-mapper/device-mapper-1.00.05.ebuild,v 1.2 2003/10/21 22:51:07 max Exp $

DESCRIPTION="Device mapper ioctl library for use with LVM2 utilities."
HOMEPAGE="http://www.sistina.com/products_lvm.htm"
SRC_URI="ftp://ftp.sistina.com/pub/LVM2/${PN}/${PN}.${PV}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"

DEPEND="virtual/linux-sources"

S="${WORKDIR}/${PN}.${PV}"

pkg_setup() {
	[ ! -e "/usr/src/linux/include/linux/dm-ioctl.h" ] && {
		eerror
		eerror "Your currently linked kernel (/usr/src/linux) hasn't"
		eerror "been patched for device mapper support."
		eerror
		die "kernel not patched for device mapper support"
	}
}

src_compile() {
	econf

	# parallel build doesn't work
	emake -j1 || die "compile problem"
}

src_install() {
	einstall sbindir="${D}/sbin" libdir="${D}/lib"
	dodoc COPYING* INSTALL INTRO README VERSION
}
