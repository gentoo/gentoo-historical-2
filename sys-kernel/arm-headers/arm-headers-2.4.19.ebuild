# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/arm-headers/arm-headers-2.4.19.ebuild,v 1.3 2003/10/27 13:49:11 aliz Exp $
#OKV=original kernel version, KV=patched kernel version.  They can be the same.

IUSE=""
DEPEND=""

ETYPE="headers"
inherit kernel eutils

#####
# move to arm profile

# this specifies the main ARM kernel patch level
ARM_PATCH_SUFFIX="rmk5"

######
# move to ${PORTDIR}/subarch.eclass
#  then move to ${PORTDIR}/profiles/profile-arm-1.4/netwinder/subarch.conf

# the current target platform
ARCH_PROFILE=netwinder

# this specifies the SUBARCH kernel patch level and download location
#  currently, only netwinder supported
SUBARCH_KERNEL_SUFFIX="-nw1"
SUBARCH_KERNEL_URLBASE="\
	http://netwinder.oregonstate.edu/users/r/ralphs/kernel/beta"
SUBARCH_KERNEL_HOMEPAGE="http://www.netwinder.org/"

#####

# set the kernel version now
OKV=2.4.19
EXTRAVERSION="${ARM_PATCH_SUFFIX}${SUBARCH_KERNEL_SUFFIX}"
KV="${OKV}-${EXTRAVERSION}"

S=${WORKDIR}/linux-${KV}

# this is the main rmk ARM Kernel Patch
ARM_KERNEL_PATCH="patch-${OKV}-${ARM_PATCH_SUFFIX}"
# this is the kernel patch for SUBARCH
[ -n "${SUBARCH_KERNEL_SUFFIX}" ] && \
	SUBARCH_KERNEL_PATCH="${ARM_KERNEL_PATCH}${SUBARCH_KERNEL_SUFFIX}" || \
	SUBARCH_KERNEL_PATCH=""

# What's in this kernel?
# INCLUDED:
#   stock 2.4.19 kernel sources
#   rmk patches for armlinux support
#	subarch patch (optional)

DESCRIPTION="Full sources for the ARM/Linux kernel"
SRC_URI="mirror://kernel/linux/kernel/v2.4/linux-${OKV}.tar.bz2 \
	ftp://ftp.arm.linux.org.uk/pub/armlinux/source/kernel-patches/v2.4/${ARM_KERNEL_PATCH}.bz2"

# note: this code is only safe because there is only one subarch
if [ -n "${SUBARCH_KERNEL_PATCH}" ]; then
	if [ -n "${SUBARCH_KERNEL_URLBASE}" ]; then
		SRC_URI="${SRC_URI} \
			${SUBARCH_KERNEL_URLBASE}/${SUBARCH_KERNEL_PATCH}.gz"
	else
		die "${SUBARCH}: ${SUBARCH_KERNEL_PATCH} does not have a URLBASE"
	fi
fi

HOMEPAGE="${SUBARCH_KERNEL_HOMEPAGE} http://www.arm.linux.org.uk/ \
		http://www.kernel.org/ http://www.gentoo.org/"
KEYWORDS="arm -hppa -x86 -ppc -sparc -alpha -mips"
SLOT="${KV}"

src_unpack() {
	# base vanilla source
	unpack "linux-${OKV}.tar.bz2" || die
	[ "${OKV}" != "${KV}" ] && \
		mv "${WORKDIR}/linux-${OKV}" "${WORKDIR}/linux-${KV}"

	# plus the Russell M. King kernel patches
	unpack "${ARM_KERNEL_PATCH}.bz2" || die

	# plus an optional SUBARCH kernel patch
	[ -n "${SUBARCH_KERNEL_PATCH}" ] && \
		{ unpack "${SUBARCH_KERNEL_PATCH}.gz" || die; }

	# do the actual patching
	cd ${S} || die
	einfo "Applying ${ARM_KERNEL_PATCH}"
	epatch "${WORKDIR}/${ARM_KERNEL_PATCH}" || die
	[ -n "${SUBARCH_KERNEL_PATCH}" ] && \
		{ epatch "${WORKDIR}/${SUBARCH_KERNEL_PATCH}" || die; }

	kernel_universal_unpack
}

src_compile() {
	# before doing the typical make oldconfig,
	#  load the specific platform configuration
	make ${ARCH_PROFILE}_config

	kernel_src_compile
}

