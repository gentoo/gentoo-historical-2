# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Daniel robbins <drobbins@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/sys-devel/automake/automake-1.4_p5.ebuild,v 1.3 2002/03/21 08:20:17 azarah Exp $

MY_P=${P/_/-}
S=${WORKDIR}/${MY_P}
DESCRIPTION="Used to generate Makefile.in from Makefile.am"
SRC_URI="ftp://prep.ai.mit.edu/gnu/automake/${MY_P}.tar.gz"
HOMEPAGE="http://www.gnu.org/software/automake/automake.html"

DEPEND="sys-devel/perl"

src_compile() {
	./configure --prefix=/usr \
		--infodir=/usr/share/info \
		--host=${CHOST} || die
		
	make ${MAKEOPTS} || die
}

src_install() {
	make prefix=${D}/usr \
		infodir=${D}/usr/share/info \
		install || die
		
	dodoc COPYING NEWS README THANKS TODO AUTHORS ChangeLog
}


