# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/yacc/yacc-1.9.1-r1.ebuild,v 1.20 2003/09/19 01:02:27 avenj Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Yacc"
SRC_URI="ftp://metalab.unc.edu/pub/Linux/devel/compiler-tools/${P}.tar.Z"
HOMEPAGE="http://dinosaur.compilertools.net/#yacc"

SLOT="0"
LICENSE="as-is"
KEYWORDS="x86 ppc sparc hppa ~alpha mips amd64 ia64"

DEPEND="virtual/glibc"

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
