# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Daniel Robbins <drobbins@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/sys-libs/nss-db/nss-db-2.2.ebuild,v 1.1 2000/11/17 01:03:07 drobbins Exp $

A=nss_db-2.2.tar.gz
S=${WORKDIR}/nss_db-2.2
DESCRIPTION="Allows important system files to be stored in a fast database file rather than plain text"
SRC_URI="ftp://ftp.gnu.org/gnu/glibc/${A}"
HOMEPAGE="http://www.gnu.org"
#now db needs to move to the base install, that's ok.
DEPEND=">=dev-db/db-3.1.17 >=sys-libs/glibc-2.2-r2"

src_compile() {
    try ./configure --with-db=/usr/include/db3 --prefix=/usr 
    try make
}

src_install () {
	make DESTDIR=${D} install
	cd ${D}
	rm usr/lib/*
	mv lib/* usr/lib
	rm -rf lib
	cd ${S}
	dodoc AUTHORS COPYING* ChangeLog NEWS README THANKS
}

