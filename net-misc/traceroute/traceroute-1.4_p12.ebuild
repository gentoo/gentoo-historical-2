# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Jerry Alexandratos <jerry@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/net-misc/traceroute/traceroute-1.4_p12.ebuild,v 1.1 2001/01/11 21:00:26 jerry Exp $

P=traceroute-1.4a12
A=${P}.tar.gz
S=${WORKDIR}/${P}
DESCRIPTION="Utility to trace the route of ip packets"
SRC_URI="ftp://ee.lbl.gov/${A}"
HOMEPAGE="http://ee.lbl.gov/"

DEPEND=">=sys-libs/glibc-2.1.3"

src_compile() {
    cd ${S}
    try ./configure --prefix=/usr --host=${CHOST}
    try make
}

src_install () {
    cd ${S}
    dodir /usr/sbin
    try make prefix=${D}/usr install

    doman traceroute.8
    dodoc CHANGES INSTALL
}
