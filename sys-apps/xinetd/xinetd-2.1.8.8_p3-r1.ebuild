# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/sys-apps/xinetd/xinetd-2.1.8.8_p3-r1.ebuild,v 1.1 2000/08/16 17:17:57 achim Exp $

P=xinetd-2.1.8.8p3
A=${P}.tar.gz
S=${WORKDIR}/${P}
DESCRIPTION="Replacement for inetd."
SRC_URI="http://www.xinetd.org/${A}"

src_compile() {                           
    ./configure --with-loadavg --with-libwrap --prefix=/usr --host=${CHOST}
    make

}

src_install() {                               
    cd ${S}
    make prefix=${D}/usr install
    prepman
    dodoc CHANGELOG README COPYRIGHT
    dodir /etc/rc.d/init.d
    cp ${O}/files/xinetd ${D}/etc/rc.d/init.d/xinetd
    cp ${O}/files/xinetd.conf ${D}/etc
}




