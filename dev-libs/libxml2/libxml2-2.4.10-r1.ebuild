# Copyright 1999-2001 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Maintainer: Daniel Robbins <drobbins@gentoo.org>,  Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libxml2/libxml2-2.4.10-r1.ebuild,v 1.2 2001/12/02 03:25:50 drobbins Exp $

S=${WORKDIR}/${P}
DESCRIPTION="libxml"
SRC_URI="ftp://ftp.gnome.org/pub/GNOME/stable/sources/libxml/${P}.tar.gz"
HOMEPAGE="http://www.gnome.org/"
DEPEND="virtual/glibc >=sys-libs/ncurses-5.2 >=sys-libs/readline-4.1 >=sys-libs/zlib-1.1.3" 

src_unpack() {
	unpack ${A}
	cd ${S}
	patch -p0 < ${FILESDIR}/libxml2-2.4.10.gentoo.diff
}

src_compile() {
	./configure --host=${CHOST}	\
		    --prefix=/usr \
		    --mandir=/usr/share/man	\
		    --sysconfdir=/etc \
		    --with-zlib  || die

	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc AUTHORS COPYING* ChangeLog NEWS README
}
