# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/nvidia-kernel/nvidia-kernel-1.0.5332-r1.ebuild,v 1.4 2004/06/30 07:58:17 cyfred Exp $

inherit eutils

PKG_V="pkg0"
NV_V="${PV/1.0./1.0-}"
NV_PACKAGE="NVIDIA-Linux-x86_64-${NV_V}"
S="${WORKDIR}/${NV_PACKAGE}-${PKG_V}/usr/src/nv"
DESCRIPTION="Linux kernel module for the NVIDIA's X driver"
HOMEPAGE="http://www.nvidia.com/"
SRC_URI="ftp://download.nvidia.com/XFree86/Linux-x86_64/${NV_V}/${NV_PACKAGE}-${PKG_V}.run"
IUSE=""

# The slot needs to be set to $KV to prevent unmerges of modules for other kernels.
LICENSE="NVIDIA"
SLOT="${KV}"
KEYWORDS="-* amd64"
RESTRICT="nostrip"

DEPEND="virtual/linux-sources"
export _POSIX2_VERSION="199209"


pkg_setup() {
	if [ ! -f /proc/mtrr ]
	then
		eerror "This version needs MTRR support for most chipsets!"
		eerror "Please enable MTRR support in your kernel config, found at:"
		eerror
		eerror "  Processor type and features -> [*] MTRR (Memory Type Range Register) support"
		eerror
		eerror "and recompile your kernel ..."
		die "MTRR support not detected!"
	fi

	check_version_h
}

check_version_h() {
	if [ ! -f "${ROOT}/usr/src/linux/include/linux/version.h" ]
	then
		eerror "Please verify that your /usr/src/linux symlink is pointing"
		eerror "to your current kernel sources, and that you did run:"
		eerror
		eerror "  # make dep"
		die "/usr/src/linux symlink not setup!"
	fi
}

get_KV_info() {
	check_version_h

	# Get the kernel version of sources in /usr/src/linux ...
	export KV_full="$(awk '/UTS_RELEASE/ { gsub("\"", "", $3); print $3 }' \
		"${ROOT}/usr/src/linux/include/linux/version.h")"
	export KV_major="$(echo "${KV_full}" | cut -d. -f1)"
	export KV_minor="$(echo "${KV_full}" | cut -d. -f2)"
	export KV_micro="$(echo "${KV_full}" | cut -d. -f3 | sed -e 's:[^0-9].*::')"
}

is_kernel() {
	[ -z "$1" -o -z "$2" ] && return 1

	get_KV_info

	if [ "${KV_major}" -eq "$1" -a "${KV_minor}" -eq "$2" ]
	then
		return 0
	else
		return 1
	fi
}

src_unpack() {
	cd ${WORKDIR}
	bash ${DISTDIR}/${NV_PACKAGE}-${PKG_V}.run --extract-only

	# Next section applies patches for linux-2.5 kernel, and/or
	# bugfixes for linux-2.4.  All these are from:
	#
	#   http://www.minion.de/nvidia/
	#
	# Many thanks to Christian Zander <zander@minion.de> for bringing
	# these to us, and being so helpful to select which to use.

	get_KV_info

	cd ${S}
	einfo "Linux kernel ${KV_major}.${KV_minor}.${KV_micro}"

	if is_kernel 2 5 || is_kernel 2 6
	then
		# Kbuild have issues currently (sandbox related).
		EPATCH_SINGLE_MSG="Applying 2.6.x patch ..." \
		epatch ${FILESDIR}/${PV}/NVIDIA-Linux-x86_64-1.0-5332-2.6.diff
	fi

	# if you set this then it's your own fault when stuff breaks :)
	[ ! -z "${USE_CRAZY_OPTS}" ] && sed -i "s:-O:${CFLAGS}:" Makefile
}

src_compile() {
	# Portage should determine the version of the kernel sources
	check_KV

	# IGNORE_CC_MISMATCH disables a sanity check that's needed when gcc has been
	# updated but the running kernel is still compiled with an older gcc.  This is
	# needed for chrooted building, where the sanity check detects the gcc of the
	# kernel outside the chroot rather than within.
	make IGNORE_CC_MISMATCH="yes" KERNDIR="/usr/src/linux" \
		clean nvidia.o || die
}

src_install() {
	# The driver goes into the standard modules location
	insinto /lib/modules/${KV}/video
	if is_kernel 2 5 || is_kernel 2 6
	then
		doins nvidia.ko
	else
		doins nvidia.o
	fi

	# Add the aliases
	insinto /etc/modules.d
	newins ${FILESDIR}/nvidia-1.1 nvidia

	# Docs
	dodoc ${S}/README

	# The device creation script
	into /
	newsbin ${S}/makedevices.sh NVmakedevices.sh
}

pkg_postinst() {
	if [ "${ROOT}" = "/" ]
	then
		# Update module dependency
		[ -x /usr/sbin/update-modules ] && /usr/sbin/update-modules
		if [ ! -e /dev/.devfsd ] && [ ! -e /dev/.udev ] && [ -x /sbin/NVmakedevices.sh ]
		then
			/sbin/NVmakedevices.sh >/dev/null 2>&1
		fi
	fi

	echo
	einfo "If you are not using devfs, loading the module automatically at"
	einfo "boot up, you need to add \"nvidia\" to your /etc/modules.autoload."
	echo
	ewarn "Please note that the driver name changed from \"NVdriver\""
	ewarn "to \"nvidia.o\"."
	echo
}
