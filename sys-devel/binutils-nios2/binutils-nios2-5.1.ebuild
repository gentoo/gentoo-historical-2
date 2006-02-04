# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/binutils-nios2/binutils-nios2-5.1.ebuild,v 1.2 2006/02/04 18:14:54 vapier Exp $

[[ ${CTARGET} != nios* && ${CATEGORY} == "sys-devel" ]] && export CTARGET="nios2-elf"

BINUTILS_TYPE="custom"
BINUTILS_VER="2.15"
inherit toolchain-binutils

# http://www.altera.com/support/kdb/2000/11/rd11272000_7307.html
SRC_URI="mirror://gentoo/niosii-gnutools-src-${PV}.tgz"

KEYWORDS="-* ~amd64 ~x86"

S=${WORKDIR}/src/binutils
