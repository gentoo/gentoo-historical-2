# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libxslt/libxslt-1.0.1.ebuild,v 1.4 2001/10/07 00:13:53 hallski Exp $

A=${P}.tar.gz
S=${WORKDIR}/${P}
DESCRIPTION="libxslt"
SRC_URI="ftp://ftp.gnome.org/pub/GNOME/stable/sources/${PN}/${A}"
HOMEPAGE="http://www.gnome.org/"

RDEPEND="virtual/glibc
	>=dev-libs/libxml2-2.4.1"

DEPEND="${RDEPEND}
	sys-devel/perl"

src_compile() {
	./configure --host=${CHOST} 					\
		    --prefix=/usr					\
		    --mandir=/usr/share/man || die

	make || die
}

src_install() {                               
        make DESTDIR=${D} install || die

	dodoc AUTHORS COPYING* ChangeLog README NEWS TODO
}
