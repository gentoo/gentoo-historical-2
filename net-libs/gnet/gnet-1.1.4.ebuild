# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/gnet/gnet-1.1.4.ebuild,v 1.8 2002/12/09 04:33:13 manson Exp $

S=${WORKDIR}/${P}
DESCRIPTION="GNet network library."
SRC_URI="http://www.gnetlibrary.org/src/${P}.tar.gz"
HOMEPAGE="http://www.gnetlibrary.org/"

SLOT="0"
LICENSE="LGPL-2.1"
KEYWORDS="x86 ppc sparc "

DEPEND=">=dev-libs/glib-1.2.0"
RDEPEND=$DEPEND

# yes, the >= is correct, this software can use both glib 1.2 and 2.0! 
src_compile() {
	econf \
		--sysconfdir=/etc \
		--localstatedir=/var/lib || die

	patch -p0 < ${FILESDIR}/gnet-docdir-gentoo.diff

	emake || die
}

src_install() {
	make \
		prefix=${D}/usr \
		datadir=${D}/usr/share \
		mandir=${D}/usr/share/man \
		infodir=${D}/usr/share/info \
		sysconfdir=${D}/etc \
		localstatedir=${D}/var/lib \
		install || die
	
	dodoc AUTHORS BUGS ChangeLog COPYING NEWS README TODO
}
