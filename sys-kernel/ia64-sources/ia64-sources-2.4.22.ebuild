# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/ia64-sources/ia64-sources-2.4.22.ebuild,v 1.1 2003/09/17 18:23:49 drobbins Exp $

IUSE=""

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
OKV="2.4.22"
KV="${KV/-r0//}"
# Documentation on the patches contained in this kernel will be installed
# to /usr/share/doc/gentoo-sources-${PV}/patches.txt.gz

MYCSET="1.1063.2.37-to-1.1088"
DESCRIPTION="Full sources for the Gentoo Kernel."
SRC_URI="mirror://kernel/linux/kernel/v2.4/linux-${OKV}.tar.bz2
http://www.kernel.org/pub/linux/kernel/ports/ia64/v2.4/testing/cset/cset-${MYCSET}.txt.gz"

HOMEPAGE="http://www.gentoo.org/ http://www.kernel.org/"
LICENSE="GPL-2"
KEYWORDS="-* ia64"
SLOT="${KV}"

src_unpack() {
	unpack linux-${OKV}.tar.bz2
	cd ${WORKDIR}
	mv linux-${OKV} linux-${KV} || die "Error moving kernel source tree to linux-${KV}"
	cd ${WORKDIR}/linux-${KV}
	[ ! -e ${DISTDIR}/cset-${MYCSET}.txt.gz ] && die "patch file not found"
	cat ${DISTDIR}/cset-${MYCSET}.txt.gz | gzip -d | patch -f -p1
	kernel_universal_unpack
}

pkg_postinst() {
	kernel_pkg_postinst
}
