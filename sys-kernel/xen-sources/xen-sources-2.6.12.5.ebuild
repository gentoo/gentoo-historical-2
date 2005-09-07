# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/xen-sources/xen-sources-2.6.12.5.ebuild,v 1.2 2005/09/07 23:24:02 chrb Exp $

ETYPE="sources"
inherit kernel-2 eutils
detect_arch
detect_version

EXTRAVERSION=".${KV_EXTRA}-xen"

DESCRIPTION="Full sources for a dom0/domU Linux kernel to run under Xen"
HOMEPAGE="http://www.cl.cam.ac.uk/Research/SRG/netos/xen/index.html"
SRC_URI="${KERNEL_URI}"

KEYWORDS="~x86"
DEPEND="=app-emulation/xen-3.0.0_pre20050906"

src_unpack() {
	# unpack kernel
	kernel-2_src_unpack

	# apply required xen patches for this kernel
	if [ -e /usr/share/xen/patches/linux-${OKV}.tar.bz2 ]; then
	    XEN_PATCHES=/usr/share/xen/patches/linux-${OKV}.tar.bz2
	    einfo "Extracting patches from ${XEN_PATCHES} ..."
	    tar -jxf ${XEN_PATCHES}
	    for p in linux-${OKV}/*.patch; do
	        epatch ${p}
	    done
	else
	    einfo "Xen has no patches for kernel ${OKV}"
	fi

	x=/usr/share/xen/linux-${KV_MAJOR}.${KV_MINOR}-xen-sparse.tar.bz2
	einfo "Copying the sparse Xen tree from ${x}"
	cd ${S}
	tar -jxf ${x}

	einfo "Setting ARCH to Xen."
	echo ARCH=xen | cat - ${S}/Makefile >${S}/Makefile.0
	mv ${S}/Makefile.0 ${S}/Makefile
}
