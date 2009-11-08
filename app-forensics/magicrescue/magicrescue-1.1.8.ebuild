# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-forensics/magicrescue/magicrescue-1.1.8.ebuild,v 1.1 2009/11/08 11:49:52 patrick Exp $

inherit eutils toolchain-funcs

DESCRIPTION="Find deleted files in block devices"
HOMEPAGE="http://jbj.rapanden.dk/magicrescue/"
SRC_URI="http://jbj.rapanden.dk/magicrescue/release/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

src_compile() {
	CC="$(tc-getCC)" ./configure --prefix=/usr || die "configure script failed"
	emake || die "emake failed"
}

src_install() {
	dodir /usr
	make PREFIX="${D}/usr" install || die "make install failed"
	mv "${D}/usr/man" "${D}/usr/share"
}
