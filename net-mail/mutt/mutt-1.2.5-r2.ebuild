# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/net-mail/mutt/mutt-1.2.5-r2.ebuild,v 1.2 2001/05/30 18:24:34 achim Exp $

P=mutt-1.2.5-1
A=mutt-1.2.5i.tar.gz
S=${WORKDIR}/mutt-1.2.5
DESCRIPTION="a small but very powerful text-based mail client"
SRC_URI="ftp://ftp.mutt.org/pub/mutt/${A}"
HOMEPAGE="http://www.mutt.org"

DEPEND="virtual/glibc
        nls? ( sys-devel/gettext )
        >=sys-libs/ncurses-5.2
	slang? ( >=sys-libs/slang-1.4.2 )
	ssl? ( >=dev-libs/openssl-0.9.6 )"

RDEPEND="virtual/glibc
        >=sys-libs/ncurses-5.2
	slang? ( >=sys-libs/slang-1.4.2 )
	ssl? ( >=dev-libs/openssl-0.9.6 )"

src_compile() {

    local myconf
    if [ -z "`use nls`" ] ; then
      myconf="--disable-nls"
    fi
    if [ "`use ssl`" ] ; then
      myconf="$myconf --with-ssl"
    fi
    if [ "`use slang`" ] ; then
      myconf="$myconf --with-slang"
    fi

    try ./configure --prefix=/usr --sysconfdir=/etc/mutt --host=${CHOST} \
	--with-regex  --enable-pop --enable-imap --enable-nfs-fix \
	--with-homespool=Maildir $myconf
    try make

}

src_install () {

    cd ${S}
    try make DESTDIR=${D} install
    prepman
    dodir /usr/doc/${P}
    mv ${D}/usr/doc/mutt/* ${D}/usr/doc/${P}
    rm -rf ${D}/usr/doc/mutt
    gzip ${D}/usr/doc/${P}/html/*
    gzip ${D}/usr/doc/${P}/samples/*
    gzip ${D}/usr/doc/${P}/*
	insinto /etc/mutt
	doins ${FILESDIR}/Muttrc*
}




