# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Daniel Robbins <drobbins@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/sys-devel/patch/patch-2.5.4-r1.ebuild,v 1.3 2000/09/15 20:09:26 drobbins Exp $

P=patch-2.5.4      
A=${P}.tar.gz
S=${WORKDIR}/${P}
DESCRIPTION="Utility to apply diffs to files"
SRC_URI="ftp://ftp.gnu.org/gnu/patch/${A}"
HOMEPAGE="http://www.gnu.org/software/patch/patch.html"

src_compile() {                           
	try ./configure --host=${CHOST} --prefix=/usr
	try make
}

src_install() {                               
	into /usr
	dobin patch
	cp patch.man patch.1
	doman patch.1
	dodoc AUTHORS COPYING ChangeLog NEWS README
}



