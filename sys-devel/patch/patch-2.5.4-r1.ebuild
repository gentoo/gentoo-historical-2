# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Daniel Robbins <drobbins@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/sys-devel/patch/patch-2.5.4-r1.ebuild,v 1.6 2001/01/31 20:49:07 achim Exp $

P=patch-2.5.4      
A=${P}.tar.gz
S=${WORKDIR}/${P}
DESCRIPTION="Utility to apply diffs to files"
SRC_URI="ftp://gatekeeper.dec.com/pub/GNU/patch/${A}
	 ftp://ftp.gnu.org/gnu/patch/${A}"
HOMEPAGE="http://www.gnu.org/software/patch/patch.html"
DEPEND="virtual/glibc"

src_compile() {                           
	try ./configure --host=${CHOST} --prefix=/usr
	try make ${MAKEOPTS}
}

src_install() {       
	try make prefix=${D}/usr install                        
	dodoc AUTHORS COPYING ChangeLog NEWS README
}



