# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/app-shells/pdksh/pdksh-5.2.14-r1.ebuild,v 1.3 2000/09/15 20:08:46 drobbins Exp $

P=pdksh-5.2.14      
A=${P}.tar.gz
S=${WORKDIR}/${P}
DESCRIPTION="The Public Domain Korn Shell"
SRC_URI="ftp://ftp.cs.mun.ca/pub/pdksh/"${A}
HOMEPAGE="http://ww.cs.mun.ca/~michael/pdksh/"

src_compile() {                           
	cd ${S}
	try ./configure --prefix=/usr --host=${CHOST}
	try make 
}

src_install() {                               
	cd ${S}
	into /
	dobin ksh
	into /usr
	doman ksh.1
	dodoc BUG-REPORTS ChangeLog* CONTRIBUTORS LEGAL NEWS NOTES PROJECTS README
	docinto etc
	dodoc etc/*
}






