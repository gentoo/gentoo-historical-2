# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Your Name <your email>
# $Header: /var/cvsroot/gentoo-x86/sys-apps/reiserfs-utils/reiserfs-utils-3.6.25-r7.ebuild,v 1.2 2001/11/06 17:05:17 g2boojum Exp $

S=${WORKDIR}/reiserfsprogs-3.x.0j
DESCRIPTION="Reiserfs Utilities"
SRC_URI="ftp://ftp.namesys.com/pub/reiserfsprogs/reiserfsprogs-3.x.0j.tar.gz"
HOMEPAGE="http://www.namesys.com"

DEPEND="virtual/glibc"

src_compile() {
    cd ${S}
    try ./configure --host=${CHOST}
    try make
}

src_install () {
	try make DESTDIR=${D} install
	dodir /usr/share
	cd ${D}
	mv man usr/share
	dosym /sbin/reiserfsck /sbin/fsck.reiserfs
	if [ "`use bootcd`" ]
	then
		rm -rf ${D}/usr
	fi
}

