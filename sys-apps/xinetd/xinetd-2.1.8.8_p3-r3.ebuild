# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/sys-apps/xinetd/xinetd-2.1.8.8_p3-r3.ebuild,v 1.1 2000/12/23 00:29:43 drobbins Exp $

P=xinetd-2.1.8.8p3
A=${P}.tar.gz
S=${WORKDIR}/${P}
DESCRIPTION="Replacement for inetd."
HOMEPAGE="http://www.xinetd.org"
SRC_URI="http://www.xinetd.org/${A}"
DEPEND=">=sys-libs/glibc-2.1.3"
RDEPEND="$DEPEND
	 >=sys-apps/bash-2.04
	 >=sys-devel/perl-5.6"

src_compile() {                           
    try ./configure --with-loadavg --with-libwrap --prefix=/usr --host=${CHOST}
    # Parallel make does not work
    try make 

}

src_install() {                               
    cd ${S}
    try make prefix=${D}/usr install
    dodoc CHANGELOG README COPYRIGHT
    exeinto /etc/rc.d/init.d
    doexe ${FILESDIR}/xinetd
	insinto /etc
#	doins ${FILESDIR}/xinetd.conf
	dodir /etc/svc.d/control
	exeinto /etc/svc.d/services/xinetd
	newexe ${FILESDIR}/xinetd-run run
	ln -s ../services/xinetd ${D}/etc/svc.d/control/xinetd
}




