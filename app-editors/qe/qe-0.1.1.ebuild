# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/qe/qe-0.1.1.ebuild,v 1.7 2004/06/24 22:01:07 agriffis Exp $

DESCRIPTION="PE2-like editor program under U*nix with Chinese support"
HOMEPAGE="http://www.cc.ncu.edu.tw/~center5/product/qe/
	http://members.xoom.com/linux4tw/qe/"
SRC_URI="ftp://freebsd.sinica.edu.tw/pub/statue/qe/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
IUSE=""
KEYWORDS="x86"

DEPEND="virtual/glibc"

src_compile() {
	./configure --prefix=/usr || die
	make all || die
}

src_install() {
	make prefix=${D}/usr install || die
	dodoc AUTHORS ChangeLog README README.big5
}
