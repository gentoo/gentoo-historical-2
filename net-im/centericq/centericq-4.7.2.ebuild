# Copyright 1999-2002 Gentoo Technologies, Inc
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/net-im/centericq/centericq-4.7.2.ebuild,v 1.1 2002/06/08 05:57:39 lostlogic Exp $

S=${WORKDIR}/${P}
DESCRIPTION="A ncurses ICQ/Yahoo!/MSN Client"
SRC_URI="http://konst.org.ua/download/${P}.tar.gz"
HOMEPAGE="http://konst.org.ua/eng/software/centericq/info.html"
SLOT="0"
DEPEND="virtual/glibc
	>=sys-libs/ncurses-5.2
	>=dev-libs/libsigc++-1.0.4"
RDEPEND="${DEPEND}"

src_unpack() {

	unpack ${P}.tar.gz
	cd ${S}
	echo "CFLAGS += ${CFLAGS}" >> Makefile.rules
	patch -p1 < ${FILESDIR}/${P}-gentoo.patch || die "Failed to patch sources"

}

src_compile() {

	./configure --prefix=/usr --host=${CHOST} || die
	emake || die

}

src_install () {
	
	make DESTDIR=${D} install || die

}


