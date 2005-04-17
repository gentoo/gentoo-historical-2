# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/xbox-sources/xbox-sources-2.6.11.7.ebuild,v 1.1 2005/04/17 15:54:11 chrb Exp $

K_NOUSENAME="yes"
K_NOSETEXTRAVERSION="yes"
ETYPE='sources'
inherit kernel-2
detect_arch
detect_version

# version of gentoo patchset
XBOX_PATCHES=xboxpatches-2.6.11-20050417.tar.bz2

KEYWORDS="~x86 -*"
UNIPATCH_LIST="
	${ARCH_PATCH}
	${DISTDIR}/${XBOX_PATCHES}"
DESCRIPTION="Full sources for the Xbox Linux kernel"
SRC_URI="${KERNEL_URI}
	${ARCH_URI}
	mirror://gentoo/${XBOX_PATCHES}"

pkg_postinst() {
	einfo ''
	einfo 'FATX WARNING: This kernel includes the new driver. There may well be bugs.'
	einfo ''
}
