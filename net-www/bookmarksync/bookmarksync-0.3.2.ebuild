# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-www/bookmarksync/bookmarksync-0.3.2.ebuild,v 1.2 2003/10/27 14:14:01 aliz Exp $

IUSE=""

S=${WORKDIR}/${P}
DESCRIPTION="bookmarksync synchronizes various browser bookmark files"
SRC_URI="mirror://sourceforge/booksync/${P}.tar.gz"
HOMEPAGE="http://sourceforge.net/projects/booksync/"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
DEPEND="virtual/glibc"


src_compile() {
	emake || die
}

src_install () {
	exeinto /usr/bin
	doexe bookmarksync
}

