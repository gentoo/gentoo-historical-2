# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/sys-build/make/make-3.79.1-r1.ebuild,v 1.1 2001/01/25 18:00:26 achim Exp $

P=make-3.79.1
A=${P}.tar.gz
S=${WORKDIR}/${P}
DESCRIPTION="Standard tool to compile source trees"
SRC_URI="ftp://gatekeeper.dec.com/pub/GNU/make/${A}
	 ftp://prep.ai.mit.edu/gnu/make/${A}"
HOMEPAGE="http://www.gnu.org/software/make/make.html"
DEPEND=">=sys-libs/glibc-2.1.3"

src_compile() {                           
	try ./configure --prefix=/usr --host=${CHOST} --disable-nls
	try  make ${MAKEOPTS} LDFLAGS=-static
}

src_install() {
	
        dobin make
}



