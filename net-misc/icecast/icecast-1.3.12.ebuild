# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author: Chris Arndt <arndtc@mailandnews.com>
# $Header $

S=${WORKDIR}/${P}
DESCRIPTION="Icecast is an Internet based broadcasting system based on the Mpeg Layer III streaming technology."
SRC_URI="http://www.icecast.org/releases/${P}.tar.gz"
HOMEPAGE="http://www.icecast.org"

DEPEND="virtual/glibc"

src_compile() {

        ./configure --with-libwrap              \
                    --with-crypt                \
                    --infodir=/usr/share/info   \
                    --mandir=/usr/share/man     \
                    --host=${CHOST} || die

        emake || die
}


src_install () {

        make DESTDIR=${D} install || die
        dodoc AUTHORS BUGS CHANGES COPYING FAQ INSTALL README TESTED TODO

}
