# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/libnet/libnet-1.1.0-r3.ebuild,v 1.1 2003/08/21 04:17:16 vapier Exp $

DESCRIPTION="library to provide an API for commonly used low-level network functions (mainly packet injection)"
HOMEPAGE="http://www.packetfactory.net/libnet/"
SRC_URI="http://www.packetfactory.net/libnet/dist/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="1.1"
KEYWORDS="x86 alpha"

S=${WORKDIR}/Libnet-latest

src_compile(){
	econf || die
	emake || die "Failed to compile"
}

src_install(){
	make DESTDIR=${D} install || die "Failed to install"
	dobin libnet-config

	dodoc VERSION README doc/*
	docinto Ancillary ; dodoc doc/Ancillary/README*
	docinto sample ; dodoc sample/*.[ch]
}
