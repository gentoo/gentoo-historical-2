# Copyright 1999-2001 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/net-libs/gnet/gnet-1.1.0.ebuild,v 1.3 2002/07/11 06:30:47 drobbins Exp $

S=${WORKDIR}/${P}
DESCRIPTION="GNet network library."
SRC_URI="http://www.gnetlibrary.org/src/${P}.tar.gz"
HOMEPAGE="http://www.gnetlibrary.org/"

DEPEND="virtual/glibc
	=dev-libs/glib-1.2*"

src_compile() {
	./configure --host=${CHOST} \
		    --prefix=/usr \
		    --mandir=/usr/share/man \
		    --infodir=/usr/share/info \
		    --sysconfdir=/etc \
		    --localstatedir=/var/lib || die

	patch -p0 < ${FILESDIR}/gnet-docdir-gentoo.diff

	emake || die
}

src_install() {
	make prefix=${D}/usr \
		mandir=${D}/usr/share/man \
		infodir=${D}/usr/share/info \
		sysconfdir=${D}/etc \
		localstatedir=${D}/var/lib \
		install || die
	
	dodoc AUTHORS BUGS ChangeLog COPYING NEWS README TODO
}
