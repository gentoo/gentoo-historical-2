# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/mips-headers/mips-headers-2.6.6-r1.ebuild,v 1.1 2004/08/30 22:59:20 kumba Exp $

ETYPE="headers"
inherit kernel eutils

OKV=${PV/_/-}
CVSDATE="20040604"
EXTRAVERSION=-mipscvs-${CVSDATE}
COBALTPATCHVER="1.4"
KV="${OKV}${EXTRAVERSION}"
S=${WORKDIR}/linux-${KV}

# What's in this kernel?

# INCLUDED:
# 1) linux sources from kernel.org
# 2) linux-mips.org CVS snapshot diff from 04 Jun 2004

DESCRIPTION="Linux Headers from Linux-Mips CVS, dated ${CVSDATE}"
SRC_URI="mirror://kernel/linux/kernel/v2.6/linux-${OKV}.tar.bz2
		mirror://gentoo/mipscvs-${OKV}-${CVSDATE}.diff.bz2"
HOMEPAGE="http://www.linux-mips.org/"
LICENSE="GPL-2"
SLOT="0"
PROVIDE="virtual/os-headers"
KEYWORDS="-*"
IUSE=""

src_unpack() {
	unpack ${A}
	mv ${WORKDIR}/linux-${OKV} ${S}
	cd ${S}

	# Update the vanilla sources with linux-mips CVS changes
	epatch ${WORKDIR}/mipscvs-${OKV}-${CVSDATE}.diff

	# Cobalt Patches
	if [ "${PROFILE_ARCH}" = "cobalt" ]; then
		echo -e ""
		einfo ">>> Patching kernel for Cobalt support ..."
		for x in ${WORKDIR}/cobalt-patches-26xx-${COBALTPATCHVER}/*.patch; do
			epatch ${x}
		done
	fi

	# Do Stuff
	kernel_universal_unpack

	# User-space patches for various things
	epatch ${FILESDIR}/${PN}-2.6.6-appCompat.patch
	epatch ${FILESDIR}/${PN}-2.6.3-strict-ansi-fix.patch
	epatch ${FILESDIR}/${PN}-2.6.0-sysctl_h-compat.patch
	epatch ${FILESDIR}/${PN}-2.6.0-fb.patch

	epatch ${FILESDIR}/${PN}-2.6.6-spaces_h-kernel.patch
}

src_compile() {
	local my_defconfig hcflags

	# Avoid issues w/ ARCH
	set_arch_to_kernel

	# Imported from linux26-headers
	# autoconf.h isnt generated unless it already exists. plus, we have no guarentee that 
	# any headers are installed on the system...
	[ -f ${ROOT}/usr/include/linux/autoconf.h ] || touch ${S}/include/linux/autoconf.h

	# CFLAGS for the kernel defconfig
	hcflags="-Wall -Wstrict-prototypes -O2 -fomit-frame-pointer -I${S}/include/"

	# Set the right defconfig
	if [ "${PROFILE_ARCH}" = "cobalt" ]; then
		my_defconfig="cobalt_defconfig"
	else
		# SGI Machine?
		case "$(uname -i)" in
			"SGI Indy"|"SGI Indigo2"|"SGI IP22")	my_defconfig="ip22_defconfig" ;;
			"SGI Origin"|"SGI IP27")		my_defconfig="ip27_defconfig" ;;
			"SGI Octane"|"SGI IP30")		my_defconfig="ip30_defconfig" ;;
			"SGI O2"|"SGI IP32")			my_defconfig="ip32_defconfig" ;;
		esac
	fi

	# Run defconfig
	make ${my_defconfig} HOSTCFLAGS="${hcflags}"

	# "Prepare" certain files
	make prepare HOSTCFLAGS="${hcflags}"

	# Back to normal
	set_arch_to_portage
}

src_install() {
	# XXX Bug in Kernel.eclass requires this fix for now.
	# XXX Remove when kernel.eclass is fixed.
	# XXX 2.4 kernels symlink 'asm' to 'asm-${ARCH}' in include/
	# XXX 2.6 kernels don't, however.  So we fix this here so kernel.eclass can find the include/asm folder
	if [ "`KV_to_int ${OKV}`" -ge "`KV_to_int 2.6.0`" ]; then
		ln -sf ${S}/include/asm-${ARCH} ${S}/include/asm
	fi

	# Do normal src_install stuff
	kernel_src_install

	# If this is 2.5 or 2.6 headers, then we need asm-generic too
	if [ "`KV_to_int ${OKV}`" -ge "`KV_to_int 2.6.0`" ]; then
		dodir /usr/include/asm-generic
		cp -ax ${S}/include/asm-generic/* ${D}/usr/include/asm-generic
	fi
}

pkg_postinst() {
	kernel_pkg_postinst

	einfo "Kernel headers are usually only used when recompiling glibc, as such, following the installation"
	einfo "of newer headers, it is advised that you re-merge glibc as follows:"
	einfo "emerge glibc"
	einfo "Failure to do so will cause glibc to not make use of newer features present in the updated kernel"
	einfo "headers."
}
