# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/virtualbox-modules/virtualbox-modules-2.1.4.ebuild,v 1.2 2009/03/05 07:32:25 vapier Exp $

# XXX: the tarball here is just the kernel modules split out of the binary
#      package that comes from virtualbox-bin

EAPI=2

inherit eutils linux-mod

MY_P=vbox-kernel-module-src-${PV}
DESCRIPTION="Kernel Modules for Virtualbox"
HOMEPAGE="http://www.virtualbox.org/"
SRC_URI="http://gentoo.zerodev.it/files/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="!=app-emulation/virtualbox-ose-9999"

S=${WORKDIR}

BUILD_TARGETS="all"
BUILD_TARGET_ARCH="${ARCH}"
MODULE_NAMES="vboxdrv(misc:${S}) vboxnetflt(misc:${S})"

pkg_setup() {
	linux-mod_pkg_setup
	BUILD_PARAMS="KERN_DIR=${KV_DIR} KERNOUT=${KV_OUT_DIR}"
	enewgroup vboxusers
}

src_prepare() {
	# Fix vboxdrv problems with 2.6.29-rc* kernels
	# http://www.virtualbox.org/ticket/3403
	if kernel_is 2 6 29 ; then
		epatch "${FILESDIR}/${PN}-2.6.29_rc.patch"
	fi
}

src_install() {
	linux-mod_src_install

	# udev rule for vboxdrv
	dodir /etc/udev/rules.d
	echo 'KERNEL=="vboxdrv", GROUP="vboxusers" MODE=660' >> "${D}/etc/udev/rules.d/60-virtualbox.rules"
}

pkg_postinst() {
	linux-mod_pkg_postinst
	elog "Starting with the 2.1 release a new kernel module was added,"
	elog "be sure to load all the needed modules."
	elog ""
	elog "Please add \"vboxdrv\" and \"vboxnetflt\" to:"
	elog "/etc/modules.autoload.d/kernel-${KV_MAJOR}.${KV_MINOR}"
	elog ""
}
