# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/librsync/librsync-0.9.7.ebuild,v 1.11 2006/08/17 19:31:22 corsair Exp $

DESCRIPTION="Flexible remote checksum-based differencing"
HOMEPAGE="http://librsync.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha ~amd64 ~arm ~hppa ia64 ppc ppc-macos ppc64 ~s390 sparc x86"
IUSE=""

DEPEND="virtual/libc"

src_compile() {
	econf --enable-shared || die
	emake || die
}

src_install () {
	make DESTDIR="${D}" install || die
	dodoc COPYING NEWS INSTALL AUTHORS THANKS README TODO
}
