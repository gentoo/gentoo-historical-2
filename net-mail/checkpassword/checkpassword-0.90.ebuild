# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/net-mail/checkpassword/checkpassword-0.90.ebuild,v 1.1 2001/05/12 16:29:26 achim Exp $

A=${P}.tar.gz
S=${WORKDIR}/${P}
DESCRIPTION="A modern replacement for sendmail which uses maildirs"
SRC_URI="http://cr.yp.to/checkpwd/${A}"

HOMEPAGE="http://www.qmail.org/"

src_compile() {
    cd ${S}
    echo "gcc ${CFLAGS}" > conf-cc
    try make
}



src_install() {                 
  into /
  dobin checkpassword
  dodoc CHANGES README TODO VERSION
}
