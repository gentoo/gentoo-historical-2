# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/tnef/tnef-1.1.1.ebuild,v 1.7 2002/12/09 04:33:15 manson Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Decodes MS-TNEF MIME attachments"
SRC_URI="http://world.std.com/~damned/${P}.tar.gz"
HOMEPAGE="http://world.std.com/~damned/software.html"

DEPEND=">=sys-libs/glibc-2.1.3"

SLOT="0"
LICENSE="GPL"
KEYWORDS="x86 sparc "

src_compile() {

    cd ${S}
    ./configure --prefix=/usr --host=${CHOST}
    emake || die

}

src_install () {

    cd ${S}
    make DESTDIR=${D} install || die
    dodoc AUTHORS BUGS ChangeLog COPYING NEWS README TODO
    doman doc/tnef.1
}


