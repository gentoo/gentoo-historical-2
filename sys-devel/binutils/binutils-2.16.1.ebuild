# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/binutils/binutils-2.16.1.ebuild,v 1.16 2006/01/12 00:42:35 vapier Exp $

PATCHVER="1.5"
UCLIBC_PATCHVER="1.0"
ELF2FLT_VER=""
inherit toolchain-binutils

# ARCH - packages to test before marking
KEYWORDS="-* ~alpha amd64 arm hppa ~ia64 mips ppc ppc64 ~s390 sh sparc x86"

src_unpack() {
	tc-binutils_unpack

	# Patches
	cd "${WORKDIR}"/patch
	# FreeBSD patches are not safe
	[[ ${CTARGET} != *-freebsd* ]] \
		&& mv 00_all_freebsd* skip/ \
		|| rm -f "${WORKDIR}"/uclibc-patches/40*all-libcs*

	tc-binutils_apply_patches
}
