# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/ltrace/ltrace-0.3.26-r1.ebuild,v 1.5 2002/11/07 01:50:05 nall Exp $

S=${WORKDIR}/${P}
DESCRIPTION="ltrace shows runtime library call information for dynamically linked executables"
SRC_URI="http://ftp.debian.org/debian/pool/main/l/ltrace/${PN}_${PV}.tar.gz"
HOMEPAGE="http://packages.debian.org/unstable/utils/ltrace.html"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 sparc sparc64 ~ppc"

DEPEND="virtual/glibc"

src_compile() {

	econf || die

	# modify CFLAGS (hopefully in a more time friendly way)
	mv Makefile Makefile.orig
	sed "s/ -O2 / ${CFLAGS} /" \
		Makefile.orig > Makefile || die "sed failed...new version of Makefile?"
	
	emake all || die
}

src_install() {

	einstall || die

	# documentation
	rm -rvf ${D}usr/doc/
	dodoc BUGS COPYING debian/changelog README TODO
}
