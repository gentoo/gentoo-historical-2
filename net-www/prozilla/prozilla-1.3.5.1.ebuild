# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-www/prozilla/prozilla-1.3.5.1.ebuild,v 1.10 2002/10/08 17:27:12 vapier Exp $

S="${WORKDIR}/${P}"
DESCRIPTION="A download manager"
SRC_URI="http://prozilla.genesys.ro/downloads/prozilla/tarballs/${P}.tar.gz"
HOMEPAGE="http://prozilla.genesys.ro/"
KEYWORDS="x86 sparc sparc64"
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
