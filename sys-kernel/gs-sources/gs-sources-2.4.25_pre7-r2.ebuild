# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/gs-sources/gs-sources-2.4.25_pre7-r2.ebuild,v 1.1 2004/02/18 19:56:45 plasmaroo Exp $

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

inherit kernel
PROVIDE="virtual/linux-sources virtual/winkernel"
OKV=2.4.24
EXTRAVERSION=_pre7-gss-r2
KV=2.4.25_pre7-gss-r2
S=${WORKDIR}/linux-${KV}

# Documentation on the patches contained in this kernel will be installed
# to /usr/share/doc/gs-sources-${PV}/patches.txt.gz

DESCRIPTION="This kernel stays up to date with current kernel -pres,
	with recent acpi,evms,win4lin,futexes,aic79xx,
	superfreeswan,preempt, and various hw fixes."
SRC_URI="mirror://kernel/linux/kernel/v2.4/linux-${OKV}.tar.bz2
	 mirror://gentoo/patches-${KV/r2/r1}.tar.bz2"
KEYWORDS="x86 -ppc -sparc"
SLOT="${KV}"

src_unpack() {
	unpack ${A}
	mv linux-${OKV} linux-${KV} || die
	cd ${KV/r2/r1} || die
	# Kill patches we aren't suppposed to use, don't worry about
	# failures, if they aren't there that is a good thing!
	# This is the ratified crypt USE flag, enables IPSEC and patch-int
	if [ -z "`use crypt`" ]; then
		einfo "No Cryptographic support, dropping patches..."
		for file in 8*;do
			einfo "Dropping ${file}..."
			rm -f ${file}
		done
	else
		einfo "Cryptographic support enabled..."
	fi

	kernel_src_unpack
	epatch ${FILESDIR}/${PN}.munmap.patch || die "Failed to apply munmap patch!"
}
