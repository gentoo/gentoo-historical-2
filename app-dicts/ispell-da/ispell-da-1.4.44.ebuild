# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-dicts/ispell-da/ispell-da-1.4.44.ebuild,v 1.4 2004/11/23 14:59:34 gustavoz Exp $

DESCRIPTION="A danish dictionary for ispell"
HOMEPAGE="http://da.speling.org/"
SRC_URI="http://da.speling.org/filer/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 sparc"
IUSE=""

DEPEND="app-text/ispell"

src_compile() {
	emake || die
}

src_install() {
	insinto /usr/lib/ispell
	doins dansk.aff dansk.hash
	dodoc README contributors
}
