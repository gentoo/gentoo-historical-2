# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/binutils/binutils-2.16.1-r3.ebuild,v 1.4 2006/07/23 16:38:36 plasmaroo Exp $

PATCHVER="1.10"
UCLIBC_PATCHVER="1.1"
ELF2FLT_VER=""
inherit toolchain-binutils

# ARCH - packages to test before marking
KEYWORDS="-* alpha amd64 arm hppa ~ia64 mips ppc ppc64 s390 sh sparc x86 ~x86-fbsd"
