# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/app-admin/sysstat/sysstat-3.3.6.ebuild,v 1.2 2002/07/06 18:49:03 drobbins Exp $

S=${WORKDIR}/${P}
DESCRIPTION="System performance tools for Linux"
SRC_URI="http://www.ibiblio.org/pub/Linux/system/status/${P}.tar.gz"
HOMEPAGE="http://perso.wanadoo.fr/sebastien.godard/"
LICENSE="GPL-2"

DEPEND="virtual/glibc
        sys-devel/gettext"
RDEPEND="virtual/glibc"
src_unpack() {
    unpack ${A}
    cd ${S}
    cp Makefile Makefile.orig
    sed -e "s:-O2:${CFLAGS}:" Makefile.orig > Makefile
}

src_compile() {

    try make PREFIX=/usr

}

src_install () {

    dodir /usr/bin
    dodir /usr/share/man/man{1,8}
    dodir /var/log/sa
    try make DESTDIR=${D} PREFIX=/usr MAN_DIR=/usr/share/man DOC_DIR=/usr/share/doc/${PF} install

}

