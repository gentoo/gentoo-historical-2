# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libspt/libspt-1.1.ebuild,v 1.3 2004/07/02 04:49:37 eradicator Exp $

DESCRIPTION="Library for handling root privilege"
HOMEPAGE="http://www.j10n.org/libspt/index.html"
SRC_URI="http://www.j10n.org/libspt/${P}.tar.bz2"

LICENSE="BSD"

SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="virtual/libc"

src_install() {

	make DESTDIR=${D} mandir=/usr/share/man install || die

	dodoc CHANGES
}
