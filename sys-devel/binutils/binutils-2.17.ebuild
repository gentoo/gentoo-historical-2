# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/binutils/binutils-2.17.ebuild,v 1.16 2006/11/17 00:00:12 vapier Exp $

PATCHVER="1.1"
UCLIBC_PATCHVER="1.0"
ELF2FLT_VER=""
inherit toolchain-binutils

# ARCH - packages to test before marking
KEYWORDS="-* ~alpha ~amd64 arm ~hppa ia64 ~mips ppc ~ppc64 sh sparc ~sparc-fbsd ~x86 ~x86-fbsd"
