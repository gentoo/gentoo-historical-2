# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Daniel Robbins <drobbins@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/dev-lang/nasm/nasm-0.98-r4.ebuild,v 1.1 2002/03/21 12:02:54 seemant Exp $

S=${WORKDIR}/${P}
DESCRIPTION="groovy little assembler"
SRC_URI="ftp://ftp.kernel.org/pub/software/devel/nasm/source/${P}.tar.bz2
	 ftp://ftp.de.kernel.org/pub/software/devel/nasm/source/${P}.tar.bz2
	 ftp://ftp.uk.kernel.org/pub/software/devel/nasm/source/${P}.tar.bz2"
HOMEPAGE="http://nasm.sourceforge.net/"

DEPEND="virtual/glibc sys-apps/texinfo"
RDEPEND="virtual/glibc"

if [ -z "`use build`" ]; then
	DEPEND="${DEPEND} sys-devel/perl"
fi

src_compile() {                           
	./configure --prefix=/usr || die

	if [ "`use build`" ]; then
		make nasm
	else
		make || die
		cd doc
		make || die
	fi
}

src_install() {
	if [ "`use build`" ]; then
		dobin nasm
	else
		dobin nasm ndisasm
		dobin rdoff/ldrdf rdoff/rdf2bin rdoff/rdfdump rdoff/rdflib rdoff/rdx
		doman nasm.1 ndisasm.1
		dodoc COPYING Changes Licence MODIFIED Readme Wishlist
		docinto txt
		cd doc
    	dodoc nasmdoc.txt
		dohtml html/*.html
    	docinto ps
    	dodoc nasmdoc.ps
    	docinto rtf
    	dodoc nasmdoc.rtf

		doinfo info/*.info*
	fi
}
