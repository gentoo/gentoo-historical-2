# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/device-mapper/device-mapper-1.00.07.ebuild,v 1.8 2004/03/10 18:37:52 max Exp $

DESCRIPTION="Device mapper ioctl library for use with LVM2 utilities."
HOMEPAGE="http://sources.redhat.com/dm/"
SRC_URI="ftp://sources.redhat.com/pub/dm/old/${PN}.${PV}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc sparc amd64"

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

	return 0
}

src_compile() {
	econf

	# Parallel build doesn't work.
	emake -j1 || die "compile problem"
}

src_install() {
	einstall sbindir="${D}/sbin" libdir="${D}/lib"
	dodoc COPYING* INSTALL INTRO README VERSION
}
