# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/selinux-sources/selinux-sources-2.4.21-r3.ebuild,v 1.1 2003/10/03 19:45:32 pebenito Exp $

IUSE="selinux"

ETYPE="sources"
inherit kernel
#KV="2.4.21-selinux"

S=${WORKDIR}/linux-${KV}
DESCRIPTION="LSM patched kernel with SELinux"
SRC_URI="http://www.kernel.org/pub/linux/kernel/v2.4/linux-${OKV}.tar.bz2
	mirror://gentoo/patches-${KV}.tar.bz2"

HOMEPAGE="http://www.kernel.org/ http://www.nsa.gov/selinux"
KEYWORDS="~x86 -ppc -alpha -sparc -mips -amd64 -ia64"
SLOT="${KV}"

src_unpack() {
	unpack ${A}
	mv linux-${OKV} linux-${KV} || die

	cd ${KV}
	kernel_src_unpack
}

src_install() {
	kernel_src_install

	dosed 's:-r0::' /usr/src/linux-${KV}/Makefile
}

