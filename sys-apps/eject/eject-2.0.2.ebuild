# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Your Name <your email>
# $Header: /var/cvsroot/gentoo-x86/sys-apps/eject/eject-2.0.2.ebuild,v 1.1 2001/03/11 22:13:01 pete Exp $

#P=
A=${P}.tar.gz
S=${WORKDIR}/${P}
DESCRIPTION=""
SRC_URI="http://www.ibiblio.org/pub/Linux/utils/disk-management/${A}"
HOMEPAGE="http://www.pobox.com/~tranter/eject.html"

DEPEND="virtual/glibc
	virtual/kernel"

src_unpack() {
    unpack ${A}
    cd ${S}
    patch -p1 < ${FILESDIR}/${P}-gentoo.diff
}

src_compile() {
    try make OPT=\""${CFLAGS}"\"
}

src_install () {
    dodir /usr/bin /usr/share/man/man1
    try make DESTDIR=${D} install
}
