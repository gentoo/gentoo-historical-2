# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/libtool/libtool-1.4-r1.ebuild,v 1.9 2002/10/04 06:34:27 vapier Exp $

A=${P}.tar.gz
S=${WORKDIR}/${P}
DESCRIPTION="A shared library tool for developers"
SRC_URI="ftp://prep.ai.mit.edu/gnu/libtool/${A}"
HOMEPAGE="http://www.gnu.org/software/libtool/libtool.html"
LICENSE="GPL-2"
KEYWORDS="x86 sparc sparc64"

DEPEND="virtual/glibc"

SLOT="0"

src_unpack() {
	unpack ${A}
	cd ${S}
	patch -p0 < ${FILESDIR}/1.4/libtool.m4.patch
}

src_compile() {
	try ./configure --prefix=/usr --infodir=/usr/share/info --host=${CHOST}
	try pmake
}

src_install() { 
	try make DESTDIR=${D} install                   
	dodoc AUTHORS COPYING ChangeLog* NEWS \
	      README THANKS TODO doc/PLATFORMS	
}




