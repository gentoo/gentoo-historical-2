# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/device-mapper/device-mapper-1.00.19-r1.ebuild,v 1.4 2004/10/01 14:34:31 blubb Exp $

inherit eutils

DESCRIPTION="Device mapper ioctl library for use with LVM2 utilities."
HOMEPAGE="http://sources.redhat.com/dm/"
SRC_URI="ftp://sources.redhat.com/pub/dm/${PN}.${PV}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ppc ~sparc ~amd64 ppc64 ~alpha"
IUSE=""

DEPEND="virtual/linux-sources"

S="${WORKDIR}/${PN}.${PV}"

pkg_setup() {
	if [ ! -e "/usr/src/linux/include/linux/dm-ioctl.h" ] ; then
		eerror
		eerror "Your currently linked kernel (/usr/src/linux) hasn't"
		eerror "been patched for device mapper support."
		eerror
		die "kernel not patched for device mapper support"
	fi

	return 0
}

src_compile() {
	econf || die "econf failed"

	# Parallel build doesn't work.
	emake -j1 || die "compile problem"
}

src_install() {
	einstall sbindir="${D}/sbin" libdir="${D}/$(get_libdir)"
	dolib.a $(get_libdir)/ioctl/libdevmapper.a

	# bug #4411
	gen_usr_ldscript libdevmapper.so || die "gen_usr_ldscript failed"

	dodoc COPYING* INSTALL INTRO README VERSION WHATS_NEW
}
