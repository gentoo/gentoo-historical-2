# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/sys-apps/fileutils/fileutils-4.0.36-r1.ebuild,v 1.2 2001/01/31 20:49:07 achim Exp $

A=${P}.tar.gz
S=${WORKDIR}/${P}
DESCRIPTION="Standard GNU file utilities (chmod, cp, dd, dir, ls, etc)"
SRC_URI="ftp://alpha.gnu.org/gnu/fetish/${A}"
HOMEPAGE="http://www.gnu.org/software/fileutils/fileutils.html"

DEPEND="virtual/glibc"

src_compile() { 
	#we are waiting for GNU fileutils 4.0.30 which will become standard in Gentoo 1.0
	#until then, we wait.
	try ./configure --prefix=/usr 
	try make ${MAKEOPTS}
}

src_install() {                               
	dodoc COPYING NEWS README*  THANKS TODO ChangeLog ChangeLog-1997 AUTHORS
	make prefix=${D}/usr install
	cd ${D}
        dodir bin
	mv usr/bin/* bin
        cd usr/bin
        ln -s ../../bin/* .
        rm -rf usr/lib
}

