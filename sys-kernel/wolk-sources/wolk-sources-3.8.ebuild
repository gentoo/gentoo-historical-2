# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/wolk-sources/wolk-sources-3.8.ebuild,v 1.1 2002/12/09 19:04:04 styx Exp $

IUSE="build"

# OKV=original kernel version, KV=patched kernel version.  They can be the same.

ETYPE="sources"

inherit kernel || die

OKV=2.4.18
KV=${OKV}-wolk$(echo ${PV} | sed s:_:-:)
EXTRAVERSION=-wolk$(echo ${PV} | sed s:_:-:)
S=${WORKDIR}/linux-${KV}
DESCRIPTION="Working Overloaded Linux Kernel"
SRC_URI="http://www.kernel.org/pub/linux/kernel/v2.4/linux-${OKV}.tar.bz2
		mirror://sourceforge/wolk/linux-${KV}-patchset.tar.bz2"
KEYWORDS="~x86"

src_unpack() {

	unpack linux-${OKV}.tar.bz2
	mv linux linux-${KV} || die

	unpack linux-${KV}-patchset.tar.bz2
	cd ${KV}-patchset

	kernel_src_unpack

	cd ${WORKDIR}
	rm -rf linux-${KV}-patchset

	cd ${WORKDIR}/linux-${KV}
}
