# Copyright 1999-2001 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/app-misc/splitvt/splitvt-1.6.5.ebuild,v 1.4 2002/07/11 06:30:16 drobbins Exp $

S=${WORKDIR}/splitvt-1.6.5
SRC_URI="http://www.devolution.com/~slouken/projects/splitvt/splitvt-1.6.5.tar.gz"

HOMEPAGE="http://www.devolution.com/~slouken/projects/splitvt"

DESCRIPTION="A program for splitting terminals into two shells"

DEPEND="virtual/glibc >=sys-libs/ncurses-5.2"

src_unpack() {
    
    unpack ${A}
    cd ${S}
    cp config.c config.orig
    cat config.orig | sed "s:/usr/local/bin:${D}/usr/bin:g" > config.c


}

src_compile() {

    try ./configure
    cp Makefile Makefile.orig
    sed -e "s:-O2:${CFLAGS}:" Makefile.orig > Makefile
    try make

}

src_install() {

    dodir /usr/bin
    try make install
    dodoc ANNOUNCE BLURB CHANGES NOTES README TODO
    doman splitvt.1

}
