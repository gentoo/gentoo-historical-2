# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/pwdb/pwdb-0.61-r4.ebuild,v 1.4 2003/01/18 13:33:15 tuxus Exp $

inherit eutils

S="${WORKDIR}/${P}"
DESCRIPTION="Password database"
SRC_URI="ftp://www.ibiblio.org/pub/Linux/distributions/gentoo/distfiles/${P}.tar.gz"
HOMEPAGE="http://www.firstlinux.com/cgi-bin/package/content.cgi?ID=6886"

LICENSE="PWDB"
KEYWORDS="x86 ppc sparc alpha mips"
SLOT="0"

DEPEND="virtual/glibc"

src_unpack () {
	mkdir ${S}
	cd ${S}
	unpack ${A}
}

src_compile() {
	cp Makefile Makefile.orig
	sed -e "s/^DIRS = .*/DIRS = libpwdb/" -e "s:EXTRAS += :EXTRAS += ${CFLAGS} :" \
		Makefile.orig > Makefile
	
	emake || die
}

src_install() {
	dodir /lib /usr/include/pwdb
	make INCLUDED=${D}/usr/include/pwdb \
		LIBDIR=${D}/lib \
		LDCONFIG="echo" \
		install || die

	preplib /
	dodir /usr/lib
	mv ${D}/lib/*.a ${D}/usr/lib

	# See bug $4411 for more info
	gen_usr_ldscript libpwdb.so

	insinto /etc
	doins conf/pwdb.conf
	
	dodoc CHANGES Copyright CREDITS README
	dohtml -r doc
	docinto txt
	dodoc doc/*.txt
}

