# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Ben Lutgens
# $Header: /home/cvsroot/gentoo-x86/app-crypt/gnupg/gnupg-1.0.4.ebuild,v 1.0
# 2001/04/21 12:45 CST blutgens  Exp $

#P=
A=${P}.tar.gz
S=${WORKDIR}/${P}
DESCRIPTION="The GNU Privacy Guard, a GPL pgp replacement"
SRC_URI="ftp://ftp.gnupg.org/pub/gcrypt/gnupg/${A}"
HOMEPAGE="http://www.gnupg.org/"

DEPEND="virtual/glibc
        nls? ( >=sys-devel/gettext-0.10.35 )
	>=sys-libs/zlib-1.1.3"

src_compile() {

# Check to see if we're using nls
   local myconf
   if [ -z "`use nls`" ]; then
	myconf="--disable-nls"
   fi

    try ./configure --prefix=/usr --mandir=/usr/share --infodir=/usr/share/info \
	--enable-static-rnd=linux --enable-m-guard --host=${CHOST}\
	${myconf}
    try make

}

src_install () {

    try make prefix=${D}/usr mandir=${D}/usr/share/man infodir=${D}/usr/share/info install
    dodoc ABOUT-NLS AUTHORS BUGS COPYING ChangeLog INSTALL NEWS PROJECTS
    dodoc README TODO VERSION
    docinto doc
    cd doc
    dodoc  FAQ HACKING DETAILS ChangeLog
    docint sgml
    dodoc gpg.sgml gpgv.sgml
    docinto html
    dodoc faq.html
    docinto txt
    dodoc faq.raw
    chmod +s ${D}/usr/bin/gpg
}

