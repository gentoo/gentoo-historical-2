# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/binutils/binutils-2.15.ebuild,v 1.1.1.1 2005/11/30 09:53:35 chriswhite Exp $

PATCHVER="1.2"
UCLIBC_PATCHVER=""
inherit toolchain-binutils

KEYWORDS="-*"

src_unpack() {
	tc-binutils_unpack

	cd "${WORKDIR}"/patch
	# FreeBSD patches are not safe
	[[ ${CTARGET} != *-freebsd* ]] && mv 00_all_freebsd* skip/

	tc-binutils_apply_patches
}
