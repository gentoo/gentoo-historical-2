# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Maintainer: Geert Bevin <gbevin@uwyn.com>
# $Header: /var/cvsroot/gentoo-x86/dev-libs/boehm-gc/boehm-gc-6.0.ebuild,v 1.1 2002/03/19 14:48:58 gbevin Exp $

S=${WORKDIR}/gc6.0
DESCRIPTION="The Boehm-Demers-Weiser conservative garbage collector can be used as a garbage collecting replacement for C malloc or C++ new. It is also used by a number of programming language implementations that use C as intermediate code."
SRC_URI="http://www.hpl.hp.com/personal/Hans_Boehm/gc/gc_source/gc6.0.tar.gz"
HOMEPAGE="http://www.hpl.hp.com/personal/Hans_Boehm/gc/"

DEPEND=">=sys-devel/gcc-2.95.3-r5"
RDEPEND=">=sys-devel/gcc-2.95.3-r5"

src_compile() {

	emake || die
	
}

src_install () {

	dodir /usr/include/gc
	insinto /usr/include/gc
	doins include/*.h 
	
	mv gc.a libgc.a
	dodir /usr/lib
	dolib.a libgc.a
	
	dodoc README.QUICK doc/README* doc/barrett_diagram
	dohtml doc
	doman doc/gc.man
}
