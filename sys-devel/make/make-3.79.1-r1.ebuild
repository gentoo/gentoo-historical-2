# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/sys-devel/make/make-3.79.1-r1.ebuild,v 1.6 2001/01/31 20:49:07 achim Exp $

P=make-3.79.1
A=${P}.tar.gz
S=${WORKDIR}/${P}
DESCRIPTION="Standard tool to compile source trees"
SRC_URI="ftp://gatekeeper.dec.com/pub/GNU/make/${A}
	 ftp://prep.ai.mit.edu/gnu/make/${A}"
HOMEPAGE="http://www.gnu.org/software/make/make.html"
DEPEND="virtual/glibc"

src_compile() {                           
	try ./configure --prefix=/usr --host=${CHOST}
	try  make ${MAKEOPTS}
}

src_install() {   
	try make DESTDIR=${D} install                            
	dodoc AUTHORS COPYING ChangeLog NEWS README* 
}



