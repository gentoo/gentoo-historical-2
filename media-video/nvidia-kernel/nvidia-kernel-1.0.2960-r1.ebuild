# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/nvidia-kernel/nvidia-kernel-1.0.2960-r1.ebuild,v 1.2 2002/10/04 05:56:40 vapier Exp $

DESCRIPTION="Linux kernel module for the NVIDIA's X driver"
HOMEPAGE="http://www.nvidia.com/"

NV_V=${PV/1.0./1.0-}
NV_PACKAGE=NVIDIA_kernel-${NV_V}
S="${WORKDIR}/${NV_PACKAGE}"
SRC_URI="ftp://download.nvidia.com/XFree86_40/${NV_V}/${NV_PACKAGE}.tar.gz
	http://download.nvidia.com/XFree86_40/${NV_V}/${NV_PACKAGE}.tar.gz"

DEPEND="virtual/linux-sources
	>=sys-apps/portage-1.9.10"

# Make sure Portage does _NOT_ strip symbols.  Need both lines for
# Portage 1.8.9+
DEBUG="yes"
RESTRICT="nostrip"

#The slow needs to be set to $KV to prevent unmerges of modules for other kernels.
SLOT="$KV"
LICENSE="NVIDIA"
KEYWORDS="x86 -ppc -sparc -sparc64"

src_compile() {
	# Portage should determine the version of the kernel sources
	check_KV
	#IGNORE_CC_MISMATCH disables a sanity check that's needed when gcc has been
	#updated but the running kernel is still compiled with an older gcc.  This is
	#needed for chrooted building, where the sanity check detects the gcc of the
	#kernel outside the chroot rather than within.
	make IGNORE_CC_MISMATCH="yes" KERNDIR="/usr/src/linux" \
		clean NVdriver || die
}

src_install () {
	# The driver goes into the standard modules location
	insinto "/lib/modules/${KV}/video"
	doins NVdriver
    
	# Add the aliases
	insinto /etc/modules.d
	doins "${FILESDIR}"/nvidia

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
		if [ ! -e /dev/.devfsd ] && [ -x /sbin/NVmakedevices.sh ]
		then
			/sbin/NVmakedevices.sh >/dev/null 2>&1
		fi
	fi

	einfo "If you are not using devfs, loading the module automatically at"
	einfo "boot up, you need to add \"NVdriver\" to your /etc/modules.autoload."
	einfo
}

