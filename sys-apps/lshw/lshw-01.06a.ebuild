# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/lshw/lshw-01.06a.ebuild,v 1.3 2004/05/12 12:55:42 pappy Exp $

inherit flag-o-matic

MAJ_PV=${PV:0:5}
MIN_PVE=${PV:5:7}
MIN_PV=${MIN_PVE/a/A}

MY_P="$PN-$MIN_PV.$MAJ_PV"
DESCRIPTION="Hardware Lister"
HOMEPAGE="http://ezix.sourceforge.net/"
SRC_URI="mirror://sourceforge/ezix/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc sparc amd64"
RESTRICT="nomirror"

DEPEND="virtual/glibc"

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}
	chmod a+r ${S}/lshw.1
}

src_compile() {
	# cpuid.cc uses inline asm and can not be linked when
	# position independent code is desired.
	filter-flags -fPIC
	emake CXX="${CXX}" CXXFLAGS="${CXXFLAGS}" || die
}

src_install() {
	make DESTDIR=${D} install || die
}
