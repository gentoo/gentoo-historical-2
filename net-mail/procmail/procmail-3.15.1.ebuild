# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Jerry Alexandratos <jerry@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/net-mail/procmail/procmail-3.15.1.ebuild,v 1.1 2001/04/19 07:14:58 jerry Exp $

A=${P}.tar.gz
S=${WORKDIR}/${P}
DESCRIPTION="Mail delivery agent/filter"
SRC_URI="http://www.procmail.org/${A}"
HOMEPAGE="http://www.procmail.org/"

DEPEND=">=sys-libs/glibc-2.1.3
        virtual/mta"

src_compile() {
    cd ${S}
    cp Makefile Makefile.orig
    sed -e "s:CFLAGS0 = -O:CFLAGS0 = ${CFLAGS}:" \
        -e "s:LOCKINGTEST=__defaults__:#LOCKINGTEST=__defaults__:" \
        -e "s:#LOCKINGTEST=/tmp:LOCKINGTEST=/tmp:" Makefile.orig > Makefile
    try make
}

src_install () {
    cd ${S}/new
    insinto /usr/bin
    insopts -m 6755
    doins procmail

    insopts -m 2755
    doins lockfile

    dobin formail mailstat

    doman *.1 *.5

    cd ${S}
    dodoc Artistic COPYING FAQ FEATURES HISTORY INSTALL KNOWN_BUGS README
}
