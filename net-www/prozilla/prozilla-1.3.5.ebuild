# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/net-www/prozilla/prozilla-1.3.5.ebuild,v 1.5 2002/07/14 20:25:23 aliz Exp $


A=${P}.tar.gz
S=${WORKDIR}/${P}
DESCRIPTION="A download manager"
SRC_URI="http://www.lintux.cx/~kalum/${A}"
HOMEPAGE="http://www.lintux.cx/~kalum/prozilla.html"
KEYWORDS="x86"
SLOT="0"
LICENSE="GPL-2"

DEPEND="virtual/glibc
	>=sys-libs/ncurses-5.2"

src_compile() {
    try ./configure --prefix=/usr --mandir=/usr/share/man --host=${CHOST} --sysconfdir=/etc
    try make
}

src_install () {
    try make DESTDIR=${D} install

    dodoc ANNOUNCE AUTHORS COPYING CREDITS ChangeLog FAQ NEWS README TODO

}

