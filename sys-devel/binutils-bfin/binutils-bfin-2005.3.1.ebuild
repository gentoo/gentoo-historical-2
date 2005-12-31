# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/binutils-bfin/binutils-bfin-2005.3.1.ebuild,v 1.1 2005/12/31 12:46:49 vapier Exp $

[[ ${CTARGET} != bfin* ]] && export CTARGET="bfin-elf"

BINUTILS_TYPE="custom"
BINUTILS_VER="2.15"
inherit toolchain-binutils

STUPID_STAMP="596"
MY_PV="3.4-2005R3.1"
DESCRIPTION="Binutils for Blackfin targets"
HOMEPAGE="http://blackfin.uclinux.org/"
SRC_URI="http://blackfin.uclinux.org/frs/download.php/${STUPID_STAMP}/bfin-gcc-${MY_PV}.tar.gz"

KEYWORDS="-* ~amd64 ~x86"

S=${WORKDIR}/bfin-gcc-${MY_PV}/binutils/binutils-${BINUTILS_VER}

src_unpack() {
	tc-binutils_unpack
	cd "${S}"
	epatch "${FILESDIR}"/${P}-build.patch
	rm -r gdb libgloss mmalloc newlib readline sim
}
