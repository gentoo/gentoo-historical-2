# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/dev-util/yacc/yacc-1.9.1-r1.ebuild,v 1.6 2001/11/10 12:45:09 hallski Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Yacc"
SRC_URI="ftp://metalab.unc.edu/pub/Linux/devel/compiler-tools/${P}.tar.Z"
DEPEND=">=sys-libs/glibc-2.1.3"

src_unpack () {
	unpack ${A}
	cd ${S}
	cp Makefile Makefile.orig
	sed -e "s:-O:${CFLAGS}:" Makefile.orig > Makefile
}
src_compile() {                           
	make clean || die
	make || die
}

src_install() {                               
	into /usr
	dobin yacc
	doman yacc.1
	dodoc 00README* ACKNOWLEDGEMENTS NEW_FEATURES NO_WARRANTY NOTES README*
}
