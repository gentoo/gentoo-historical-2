# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/librsync/librsync-0.9.6.ebuild,v 1.10 2009/09/23 18:50:06 patrick Exp $

DESCRIPTION="Flexible remote checksum-based differencing"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
HOMEPAGE="http://librsync.sf.net/"

DEPEND=""

SLOT="0"
LICENSE="LGPL-2.1"
KEYWORDS="x86 sparc ~ppc ~amd64"
IUSE=""

src_compile() {
	./configure --prefix=/usr --host=${CHOST} --enable-shared || die
	emake || die
}

src_install () {
	make prefix=${D}/usr \
		mandir=${D}/usr/share/man \
		install  || die

	dodoc COPYING NEWS INSTALL AUTHORS THANKS README TODO
}
