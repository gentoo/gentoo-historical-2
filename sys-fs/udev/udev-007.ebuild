# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/udev/udev-007.ebuild,v 1.1 2003/11/24 18:36:23 azarah Exp $

# Note: Cannot use external libsysfs with klibc ..
USE_KLIBC="no"
USE_EXT_LIBSYSFS="no"

inherit eutils

DESCRIPTION="udev - Linux dynamic device naming support (aka userspace devfs)"
HOMEPAGE="http://www.kernel.org/"
SRC_URI="mirror://kernel/linux/utils/kernel/hotplug/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"

DEPEND="virtual/glibc
	>=sys-apps/hotplug-20030805-r1
	>=sys-fs/sysfsutils-0.3.0"

pkg_setup() {
	[ "${USE_KLIBC}" = "yes" ] && check_KV

	return 0
}

src_unpack() {
	unpack ${A}

	cd ${S}
	# No need to clutter the logs ...
	sed -ie '/^DEBUG/ c\DEBUG = false' Makefile
	# Do not use optimization flags from the package
	sed -ie 's|$(OPTIMIZATION)||g' Makefile

	# Make sure we do not build included libsysfs, but link to
	# one in sysfsutils ...
	if [ "${USE_EXT_LIBSYSFS}" = "yes" -a "${USE_KLIBC}" != "yes" ]
	then
		rm -rf ${S}/libsysfs
		cp -Rd ${ROOT}/usr/include/sysfs ${S}/libsysfs
	fi

	# Setup things for klibc
	if [ "${USE_KLIBC}" = "yes" ]
	then
		ln -snf ${ROOT}/usr/src/linux ${S}/klibc/linux
	fi

	# Do not sefault if we forget to put a ':' between group and permissions
	epatch ${FILESDIR}/${P}-check-valid-mode.patch
}

src_compile() {
	# Do not work with emake
	if [ "${USE_EXT_LIBSYSFS}" = "yes" -a "${USE_KLIBC}" != "yes" ]
	then
		make udevdir="/dev/" \
			ARCH_LIB_OBJS="-lsysfs" \
			SYSFS="" || die
	else
		make udevdir="/dev/" || die
	fi
}

src_install() {
	into /
	dosbin udev

	insinto /etc/udev
	doins udev.config
	# Our own custom udev.permissions
	doins ${FILESDIR}/udev.permissions
#	doins udev.permissions

	dodir /etc/hotplug.d/default
	dosym ../../../sbin/udev /etc/hotplug.d/default/udev.hotplug

	doman udev.8

	dodoc COPYING ChangeLog FAQ README TODO
	dodoc docs/{overview,udev-OLS2003.pdf}
}

