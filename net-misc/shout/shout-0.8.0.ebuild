# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/shout/shout-0.8.0.ebuild,v 1.7 2002/12/09 04:33:19 manson Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Shout is a program for creating a mp3 stream for use with icecast or shoutcast"
SRC_URI="http://www.icecast.org/releases/${P}.tar.gz"
HOMEPAGE="http://www.icecast.org"
KEYWORDS="x86 sparc "
LICENSE="GPL"
SLOT="0"

DEPEND="virtual/glibc"

src_compile() {

        ./configure --prefix=/usr		\
		    --infodir=/usr/share/info   \
                    --mandir=/usr/share/man     \
                    --host=${CHOST} || die

        emake || die
}


src_install () {

        make DESTDIR=${D} install || die
        dodoc BUGS CREDITS README.shout TODO

}
