# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/vanilla-sources/vanilla-sources-2.4.21.ebuild,v 1.6 2003/11/18 18:09:50 iggy Exp $
#OKV=original kernel version, KV=patched kernel version.  They can be the same.

OKV=2.4.21
KV=2.4.21
EXTRAVERSION=" "
S=${WORKDIR}/linux-${KV}
ETYPE="sources"
inherit kernel

# What's in this kernel?

# INCLUDED:
# stock 2.4.21 kernel sources

DESCRIPTION="Full sources for the Linux kernel"
SRC_URI="mirror://kernel/linux/kernel/v2.4/linux-${OKV}.tar.bz2"
HOMEPAGE="http://www.kernel.org/ http://www.gentoo.org/"
KEYWORDS="x86 ppc sparc alpha amd64"
SLOT="${KV}"

src_unpack() {
	unpack linux-${OKV}.tar.bz2

	cd ${S}

	kernel_universal_unpack
}
