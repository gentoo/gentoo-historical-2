# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/net-misc/whois/whois-4.5.28.ebuild,v 1.3 2002/07/11 06:30:49 drobbins Exp $

A=whois_${PV}.tar.gz
S=${WORKDIR}/${P}
DESCRIPTION="improved Whois Client"
SRC_URI="ftp://ftp.debian.org/debian/pool/main/w/whois/${A}"
HOMEPAGE="http://www.linux.it/~md/software/"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"

DEPEND="virtual/glibc >=sys-devel/perl-5"
RDEPEND="virtual/glibc"

src_unpack() {

    unpack ${A}
    cd ${S}
    cp Makefile Makefile.orig
    sed -e "s/-O2/$CFLAGS/" -e "s:/man/man1/:/share/man/man1/:" Makefile.orig > Makefile
    cd po
    cp Makefile Makefile.orig
    sed -e "s:/usr/bin/install:/bin/install:" Makefile.orig > Makefile

}

src_compile() {

    make || die
    make mkpasswd || die

}

src_install() {
    dodir /usr/bin
    dodir /usr/share/man/man1
    dodir /usr/share/locale
    make BASEDIR=${D} prefix=/usr mandir=/usr/share/man install || die
    dobin mkpasswd
    doman mkpasswd.1
    dodoc README TODO debian/changelog debian/copyright

}
