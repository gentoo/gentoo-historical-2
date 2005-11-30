# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libtrain/libtrain-0.9b.ebuild,v 1.1.1.1 2005/11/30 09:41:26 chriswhite Exp $

DESCRIPTION="Library for calculating fastest train routes"
SRC_URI="http://www.on.rim.or.jp/~katamuki/software/train/${P}.tar.gz"
HOMEPAGE="http://www.on.rim.or.jp/~katamuki/software/train/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~ppc sparc x86"
IUSE=""

DEPEND="virtual/libc"

src_compile() {
	econf || die
	emake || die
}

src_install () {
	make DESTDIR=${D} install || die
}
