# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Daniel Robbins <drobbins@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/sys-libs/nss-db/nss-db-2.2-r1.ebuild,v 1.3 2002/07/09 12:51:12 aliz Exp $

A=nss_db-${PV}.tar.gz
S=${WORKDIR}/nss_db-${PV}
DESCRIPTION="Allows important system files to be stored in a fast database file rather than plain text"
SRC_URI="ftp://ftp.gnu.org/gnu/glibc/${A}"
HOMEPAGE="http://www.gnu.org"
#now db needs to move to the base install, that's ok.
LICENSE="GPL-2"
DEPEND=">=sys-libs/db-3.2.3-r1
        sys-devel/gettext"
KEYWORDS="x86"
SLOT="0"
RDEPEND=">=sys-libs/db-3.2.3-r1"


src_compile() {

    try ./configure --with-db=/usr/include/db3 --prefix=/usr --libdir=/usr/lib
    try make ${MAKEOPTS}

}

src_install () {

	make DESTDIR=${D} install

	rm -rf ${D}/usr/lib
	cd ${D}/lib
	ln -s libnss_db-${PV}.so libnss_db.so

	cd ${S}
	dodoc AUTHORS COPYING* ChangeLog NEWS README THANKS
}

