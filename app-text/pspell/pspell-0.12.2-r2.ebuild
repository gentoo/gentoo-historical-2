# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author: Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/app-text/pspell/pspell-0.12.2-r2.ebuild,v 1.3 2002/04/28 03:59:29 seemant Exp $

#Remove leading zero from version number
MYPV=${PV#0}
S=${WORKDIR}/${PN}-${MYPV}
DESCRIPTION="A spell checker frontend for aspell and ispell"
SRC_URI="http://prdownloads.sourceforge.net/${PN}/${PN}-${MYPV}.tar.gz"
HOMEPAGE="http://pspell.sourceforge.net"

DEPEND="virtual/glibc
	>=sys-devel/libtool-1.4.1-r4"


src_compile() {

	libtoolize --copy --force --automake
	
	./configure \
		--prefix=/usr \
		--exec-prefix=/usr \
		--bindir=/usr/bin \
		--sharedstatedir=/var/lib \
		--enable-doc-dir=/usr/share/doc/${PF} \
		--enable-ltdl \
		--host=${CHOST} || die "./configure failed"
		
	emake || die "Parallel Make Failed"
}

src_install () {

	make DESTDIR=${D} install || die "Installation Failed"
    
	dodoc README*
    
	cd ${D}/usr/share/doc/${PF}
	mv man-html html
	mv man-text txt
}
