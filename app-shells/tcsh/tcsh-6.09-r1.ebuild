# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/app-shells/tcsh/tcsh-6.09-r1.ebuild,v 1.4 2000/09/15 20:08:46 drobbins Exp $

P=tcsh-6.09      
A=${P}.tar.gz
S=${WORKDIR}/${P}.00
DESCRIPTION="The standard GNU Bourne again shell"
#ugh, astron.com doesn't support passive ftp... maybe another source?
SRC_URI="ftp://ftp.astron.com/pub/tcsh/"${A}

src_compile() {                           
	cd ${S}
	try ./configure --prefix=/ --mandir=/usr/man --host=${CHOST}
	try make
}

src_install() {                               
	cd ${S}
	try make DESTDIR=${D} install install.man
	prepman
	perl tcsh.man2html
	dodoc FAQ Fixes NewThings Ported README WishList Y2K
	docinto html
	dodoc tcsh.html/*.html
}



