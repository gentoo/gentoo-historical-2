# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/xxl/xxl-1.0.0.ebuild,v 1.4 2004/07/02 04:58:04 eradicator Exp $

DESCRIPTION="C/C++ library that provides exception handling and asset management"
HOMEPAGE="http://www.zork.org/xxl/"
SRC_URI="http://www.zork.org/software/${P}.tar.gz"

LICENSE="ZORK"
SLOT="0"
KEYWORDS="x86"

DEPEND="virtual/libc"

src_install() {
	emake install DESTDIR=${D} || die
	dodoc README
}
