# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/cdb/cdb-0.75.ebuild,v 1.5 2003/02/13 10:01:20 vapier Exp $

S=${WORKDIR}/${P}
DESCRIPTION="A fast, reliable, simple package for creating and reading constant databases"
SRC_URI="http://cr.yp.to/cdb/${P}.tar.gz"
HOMEPAGE="http://cr.yp.to/cdb.html"
SLOT="0"
# is this license correct?
LICENSE="as-is"
KEYWORDS="x86"

DEPEND="sys-apps/tar sys-apps/gzip"
RDEPEND="virtual/glibc"

src_compile() {                           
	echo "gcc ${CFLAGS}" > conf-cc
	echo "gcc" > conf-ld
	echo "/usr" > conf-home
	emake || die "emake failed"
}

src_install() {                               
	exeinto /usr/bin
	for i in cdbdump cdbget cdbmake cdbmake-12 cdbmake-sv cdbstats cdbtest
	do
		doexe $i
	done

	into /usr
	newlib.a cdb.a libcdb.a
	insinto /usr/include
	doins cdb.h

	dodoc CHANGES FILES README SYSDEPS TARGETS TODO VERSION
}
