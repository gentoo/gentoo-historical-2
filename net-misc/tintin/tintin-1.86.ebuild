# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/tintin/tintin-1.86.ebuild,v 1.2 2002/07/09 11:15:22 phoenix Exp $

# Author gaarde <gaarde at users dot sourceforge dot net>

S=${WORKDIR}/tintin++/src
DESCRIPTION="(T)he k(I)cki(N) (T)ickin d(I)kumud clie(N)t"
SRC_URI="http://mail.newclear.net/tintin/download/tintin++v${PV}.tar.gz"
HOMEPAGE="http://mail.newclear.net/tintin/"
LICENSE="GPL-2"
KEYWORDS="x86"
SLOT="0"

DEPEND="sys-libs/ncurses"

src_compile() {
	./configure \
		--host=${CHOST} \
		--prefix=/usr \
		--infodir=/usr/share/info \
		--mandir=/usr/share/man || die "./configure failed"
	emake CFLAGS="$CFLAGS" || die
}

src_install () {
	dobin tt++

	dodoc ../BUGS ../CHANGES ../CREDITS ../FAQ ../INSTALL ../README \
		../TODO ../docs/*
}
