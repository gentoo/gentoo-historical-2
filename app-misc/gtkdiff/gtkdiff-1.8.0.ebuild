# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/app-misc/gtkdiff/gtkdiff-1.8.0.ebuild,v 1.4 2002/07/11 06:30:16 drobbins Exp $

S=${WORKDIR}/${P}
DESCRIPTION="GTK Frontend for diff"
SRC_URI="http://www.ainet.or.jp/~inoue/software/gtkdiff/${P}.tar.gz"
HOMEPAGE="http://www.ainet.or.jp/~inoue/software/gtkdiff/index-e.html"

DEPEND=">=gnome-base/gnome-libs-1.4.1.2-r1"

src_compile() {
	./configure --host=${CHOST}					\
		    --prefix=/usr					\
		    --sysconfdir=/etc
	assert

	emake || die
}

src_install () {
	make prefix=${D}/usr sysconfdir=${D}/etc install || die

	dodoc AUTHORS COPYING ChangeLog NEWS README TODO 
}
