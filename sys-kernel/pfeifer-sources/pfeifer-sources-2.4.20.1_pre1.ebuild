# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/pfeifer-sources/pfeifer-sources-2.4.20.1_pre1.ebuild,v 1.5 2003/03/21 20:40:17 pfeifer Exp $

IUSE="build crypt"

# OKV=original kernel version, KV=patched kernel version.  They can be the same.

# Kernel ebuilds using the kernel.eclass can remove any patch that you
# do not want to apply by simply setting the KERNEL_EXCLUDE shell
# variable to the string you want to exclude (for instance
# KERNEL_EXCLUDE="evms" would not patch any patches whose names match
# *evms*).  Kernels are only tested in the default configuration, but
# this may be useful if you know that a particular patch is causing a
# conflict with a patch you personally want to apply, or some other
# similar situation.

ETYPE="sources"

inherit kernel || die
OKV="2.4.20"
# Documentation on the patches contained in this kernel will be installed
# to /usr/share/doc/pfeifer-sources-${PV}/patches.txt.gz

DESCRIPTION="Full sources for the experimental Gentoo Kernel. Patches from here may move into sys-kernel/gentoo-sources"
SRC_URI="http://www.kernel.org/pub/linux/kernel/v2.4/linux-${OKV}.tar.bz2
	mirror://gentoo/patches-${KV}.tar.bz2"
HOMEPAGE="http://www.gentoo.org/ http://www.kernel.org/"
LICENSE="GPL-2"
KEYWORDS="x86 -ppc -sparc -alpha -hppa -mips -arm"
SLOT="${KV}"


src_unpack() {
	unpack ${A}
	mv linux-${OKV} linux-${KV} || die

	cd ${KV}
	# Kill patches we aren't suppposed to use, don't worry about
	# failures, if they aren't there that is a good thing!
	# If the compiler isn't gcc3 drop the gcc3 patches
	if [[ "${COMPILER}" == "gcc3" ]];then
		einfo "You are using gcc3.x"
		einfo "Enabling gcc>31 processor optimizations."
		einfo "To use, choose the processor family labelled with (gcc>31) in"
		einfo "Processor type and features -> Processor Family"
	else
		einfo "Your compiler is not gcc3, dropping patches..."
		for file in *gcc3*;do
			einfo "Dropping ${file}..."
			rm -f ${file}
		done
	fi

	# This is the ratified crypt USE flag, enables IPSEC & USAGI
	if [ -z "`use crypt`" ]; then
		einfo "No Cryptographic support, dropping patches..."
		for file in 6* 7* 8* ;do
			einfo "Dropping ${file}..."
			rm -f ${file}
		done
	else
		einfo "Cryptographic support enabled..."
	fi

	kernel_src_unpack
}

pkg_postinst() {

	kernel_pkg_postinst

	ewarn "There is no xfs support in this kernel."
	ewarn "If you need xfs support, emerge xfs-sources."
	echo
	einfo "Please be warned, you have just installed a untested"
	einfo "patchset of the Gentoo Linux kernel sources."
	einfo "This set contains the ptrace patch."
	einfo "If there are issues with it, please report them"
	einfo "by assigning bugs on bugs.gentoo.org to"
	einfo "x86-kernel@gentoo.org"
}
