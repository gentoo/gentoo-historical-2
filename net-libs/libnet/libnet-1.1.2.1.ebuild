# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/libnet/libnet-1.1.2.1.ebuild,v 1.3 2004/05/05 21:51:26 vapier Exp $

DESCRIPTION="library to provide an API for commonly used low-level network functions (mainly packet injection)"
HOMEPAGE="http://www.packetfactory.net/libnet/"
SRC_URI="http://www.packetfactory.net/libnet/dist/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="1.1"
KEYWORDS="x86 ppc sparc mips alpha arm hppa amd64"
IUSE=""

S=${WORKDIR}/libnet

src_install(){
	make DESTDIR=${D} install || die "Failed to install"
	dobin libnet-config || die

	doman doc/man/man3/*.3
	dodoc VERSION README doc/*
	dohtml -r doc/html/*
	docinto sample ; dodoc sample/*.[ch]
}
