# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/cloop/cloop-1.02.ebuild,v 1.1 2004/11/23 22:36:14 genstef Exp $

inherit kernel-mod

MY_PV="${PV}-1"
MY_P="${PN}_${MY_PV}"
DESCRIPTION="Compressed filesystem loopback kernel module"
HOMEPAGE="http://www.knopper.net/knoppix/"
SRC_URI="http://developer.linuxtag.net/knoppix/sources/${MY_P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""
DEPEND=""

# Run-time dependencies, same as DEPEND if RDEPEND isn't defined:
#RDEPEND=""

S=${WORKDIR}/${PN}-${PV}

badversion () {
	eerror "This version of cloop will only compile against Linux 2.4.x"
	eerror "Please change where /usr/src/linux points to, or export the KERNEL_DIR"
	eerror "environment variable like this:"
	eerror
	eerror "  KERNEL_DIR=\"<dir>\" emerge cloop"

	die "cloop ${PV} only works with Linux 2.4"
}

badconfig () {
	eerror "You have not enabled the zlib compression and/or decompression options"
	eerror "in your Linux kernel."
	eerror
	eerror "You must configure both options to be compiled into your kernel; cloop"
	eerror "will not compile if the zlib options are compiled as modules"
	die
}

src_compile() {
	kernel-mod_getversion
	[ "$KV_MAJOR" = "2" ] && [ "$KV_MINOR" != "4" ] && badversion

	. ${KERNEL_DIR}/.config || die "kernel has not been configured yet"
	[ "$CONFIG_ZLIB_INFLATE" != "y" ] && badconfig
	[ "$CONFIG_ZLIB_DEFLATE" != "y" ] && badconfig

	kernel-mod_src_compile
}

src_install() {
	insinto /lib/modules/$KV_VERSION_FULL/misc
	doins cloop.o
	dobin create_compressed_fs extract_compressed_fs
	cp debian/create_compressed_fs.1 debian/extract_compressed_fs.1
	doman debian/create_compressed_fs.1 debian/extract_compressed_fs.1
	dodoc CHANGELOG README
}

pkg_postinst () {
	einfo "Adding /dev/cloop device"
	if [ -e /dev/cloop ] ; then
		rm -f /dev/cloop
	fi
	mknod /dev/cloop b 240 0 || die
}
