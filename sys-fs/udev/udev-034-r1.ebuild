# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/udev/udev-034-r1.ebuild,v 1.1 2004/10/10 04:19:46 gregkh Exp $

# Note: Cannot use external libsysfs with klibc ..
USE_KLIBC="no"

inherit eutils

DESCRIPTION="Linux dynamic and persistent device naming support (aka userspace devfs)"
HOMEPAGE="http://www.kernel.org/pub/linux/utils/kernel/hotplug/udev-FAQ"
SRC_URI="mirror://kernel/linux/utils/kernel/hotplug/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~arm ~alpha ~amd64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86"
IUSE=""

DEPEND="virtual/libc
	sys-apps/hotplug-base"
RDEPEND="${DEPEND}
	>=sys-apps/baselayout-1.8.6.12-r3"
# We need some changes for devfs type layout
PROVIDE="virtual/dev-manager"

pkg_setup() {
	[ "${USE_KLIBC}" = "yes" ] && check_KV

	return 0
}

src_unpack() {
	unpack ${A}

	cd ${S}

	# patches go here...
	# epatch ${FILESDIR}/${P}-udev_add_c-gcc295-compat.patch

	# No need to clutter the logs ...
	sed -ie '/^DEBUG/ c\DEBUG = false' Makefile
	# Do not use optimization flags from the package
	sed -ie 's|$(OPTIMIZATION)||g' Makefile

	# Make sure there is no sudden changes to udev.rules.gentoo
	# (more for my own needs than anything else ...)
	if [ "`md5sum < "${S}/etc/udev/udev.rules.gentoo"`" != \
	     "2ad43ee9c7a5a0bec284725755403ee0  -" ]
	then
		echo
		eerror "udev.rules.gentoo has been updated, please validate!"
		die "udev.rules.gentoo has been updated, please validate!"
	fi

	# Setup things for klibc
	if [ "${USE_KLIBC}" = "yes" ]
	then
		ln -snf ${ROOT}/usr/src/linux ${S}/klibc/linux
	fi
}

src_compile() {
	local myconf=
	local extras="extras/scsi_id extras/volume_id"

	# Do not work with emake
	make EXTRAS="${extras}" \
		udevdir="/dev/" \
		${myconf} || die
}

src_install() {
	dobin udevinfo
	dobin udevtest
	into /
	dosbin udev
	dosbin udevd
	dosbin udevsend
	dosbin wait_for_sysfs
	dosbin extras/scsi_id/scsi_id
	dosbin extras/volume_id/udev_volume_id
	dosym /sbin/udev /sbin/udevstart

	exeinto /etc/udev/scripts
	doexe extras/ide-devfs.sh
	doexe extras/scsi-devfs.sh

	insinto /etc/udev
	newins ${FILESDIR}/udev.conf.post_024 udev.conf

	# For devfs style layout
	insinto /etc/udev/rules.d/
	newins etc/udev/udev.rules.gentoo 50-udev.rules

	# Our own custom udev.permissions
	insinto /etc/udev/permissions.d/
	newins etc/udev/udev.permissions.gentoo 50-udev.permissions
	insinto /etc
	doins extras/scsi_id/scsi_id.config

	# set up symlinks in /etc/hotplug.d/default
	dodir /etc/hotplug.d/default
	dosym ../../../sbin/udevsend /etc/hotplug.d/default/10-udev.hotplug
	dosym ../../../sbin/wait_for_sysfs /etc/hotplug.d/default/05-wait_for_sysfs.hotplug

	# set up the /etc/dev.d directory tree
	dodir /etc/dev.d/default
	dodir /etc/dev.d/net
	exeinto /etc/dev.d/net
	doexe etc/dev.d/net/hotplug.dev

	doman *.8
	doman extras/scsi_id/scsi_id.8

	dodoc COPYING ChangeLog FAQ HOWTO-udev_for_dev README TODO
	dodoc docs/{overview,udev-OLS2003.pdf,udev_vs_devfs,RFC-dev.d}
	newdoc extras/volume_id/README README_volume_id
}

pkg_preinst() {
	if [ -f "${ROOT}/etc/udev/udev.config" -a \
	     ! -f "${ROOT}/etc/udev/udev.rules" ]
	then
		mv -f ${ROOT}/etc/udev/udev.config ${ROOT}/etc/udev/udev.rules
	fi

	# delete the old udev.hotplug symlink if it is present
	if [ -f "${ROOT}/etc/hotplug.d/default/udev.hotplug" ]
	then
		rm -f ${ROOT}/etc/hotplug.d/default/udev.hotplug
	fi
}

pkg_postinst() {
	if [ "${ROOT}" = "/" -a -n "`pidof udevd`" ]
	then
		killall -15 udevd &>/dev/null
		sleep 1
		killall -9 udevd &>/dev/null
	fi
}
