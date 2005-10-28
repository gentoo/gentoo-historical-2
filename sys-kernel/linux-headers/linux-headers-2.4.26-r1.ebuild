# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/linux-headers/linux-headers-2.4.26-r1.ebuild,v 1.9 2005/10/28 01:08:43 vapier Exp $

ETYPE="headers"
H_SUPPORTEDARCH="arm m68k sh sparc x86"
inherit eutils kernel-2
detect_version

SRC_URI="${KERNEL_URI}"
KEYWORDS="-* arm m68k sh ~sparc ~x86"

UNIPATCH_LIST="${FILESDIR}/linux-headers-2.4-armeb-stat.patch
	${FILESDIR}/linux-headers-2.4-arm-cris-ELF_DATA.patch
	${FILESDIR}/unistd.h-i386-pic.patch"
