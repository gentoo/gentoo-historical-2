# Copyright 1999-2001 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/net-mail/fetchmail/fetchmail-5.8.8.ebuild,v 1.1 2001/06/21 16:15:30 g2boojum Exp $

A=${P}.tar.gz
S=${WORKDIR}/${P}
DESCRIPTION="fetchmail"
SRC_URI="http://www.tuxedo.org/~esr/fetchmail/"${A}
HOMEPAGE="http://www.tuxedo.org/~esr/fetchmail/"

DEPEND="virtual/glibc
	ssl? ( >=dev-libs/openssl-0.9.6 )
	nls? ( sys-devel/gettext )"

src_compile() {
    local myconf
    if [ "`use ssl`" ] ; then
       export CFLAGS="$CFLAGS -I/usr/include/openssl"
       myconf="--with-ssl"
    fi
    if [ -z "`use nls`" ] ; then
	myconf="$myconf --disable-nls"
    fi
    try ./configure --prefix=/usr --host=${CHOST} \
        --mandir=/usr/share/man \
	--enable-RPA --enable-NTLN \
	--enable-SDPS $myconf
    try make
}


src_install() {
    try make DESTDIR=${D} install
    dodoc FAQ FEATURES ABOUT-NLS NEWS NOTES README README.NTLM \
          TODO COPYING MANIFEST
    docinto html
    dodoc *.html
    docinto contrib
    dodoc contrib/*
}
