# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-sci/libgdgeda/libgdgeda-2.0.15.ebuild,v 1.6 2004/06/24 22:08:11 agriffis Exp $

HOMEPAGE="http://www.geda.seul.org"
DESCRIPTION="libgdgeda - a PNG creation library for gEDA"
SRC_URI="http://www.geda.seul.org/dist/${P}.tar.gz"

IUSE=""
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc"
SLOT="0"

DEPEND=">=media-libs/libpng-1.2.1
	>=sys-libs/zlib-1.1.4
	virtual/x11"

src_compile() {

	econf || die
	emake || die

}

src_install () {

	einstall || die
	dodoc COPYING README.1ST

}
