# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/app-sci/xcircuit/xcircuit-2.5.4.ebuild,v 1.2 2002/07/11 06:30:18 drobbins Exp $

S=${WORKDIR}/${P}

DESCRIPTION="Circuit drawing and schematic capture program."

SRC_URI="http://bach.ece.jhu.edu/~tim/programs/xcircuit/archive/${P}.tar.bz2"

HOMEPAGE="http://bach.ece.jhu.edu/~tim/programs/xcircuit/xcircuit.html"

DEPEND="virtual/x11
		dev-lang/python
		app-text/ghostscript"

src_compile() {
	
	./configure \
		--host=${CHOST} \
		--prefix=/usr \
		--mandir=/usr/share/man || die "./configure failed"
	
	#Parallel make bombs on parameter.c looking for menudep.h
	make || die

}

src_install () {

	make DESTDIR=${D} install || die "Installation failed"
	
	dodoc COPYRIGHT README*

}
