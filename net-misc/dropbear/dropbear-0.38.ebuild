# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/dropbear/dropbear-0.38.ebuild,v 1.1 2003/10/11 17:58:55 vapier Exp $

DESCRIPTION="small SSH 2 server designed for small memory environments"
HOMEPAGE="http://matt.ucc.asn.au/dropbear/"
SRC_URI="http://matt.ucc.asn.au/dropbear/releases/${P}.tar.bz2"

LICENSE="as-is"
SLOT="0"
KEYWORDS="x86 ppc"
IUSE="zlib"

DEPEND="zlib? ( sys-libs/zlib )"

src_compile() {
	econf `use_enable zlib` || die
	emake || die
}

src_install() {
	dodir /usr/{s,}bin
	make install DESTDIR=${D} || die
	dodoc CHANGES README TODO
}
