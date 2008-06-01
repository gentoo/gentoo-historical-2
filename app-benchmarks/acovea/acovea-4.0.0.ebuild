# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-benchmarks/acovea/acovea-4.0.0.ebuild,v 1.7 2008/06/01 16:58:14 pchrist Exp $

DESCRIPTION="Analysis of Compiler Options via Evolutionary Algorithm"
HOMEPAGE="http://www.coyotegulch.com/products/acovea/"
SRC_URI="http://www.coyotegulch.com/products/acovea/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""
DEPEND="dev-libs/libcoyotl
	dev-libs/libevocosm
	dev-libs/expat
	>=sys-devel/gcc-3.3"

src_install() {
	make DESTDIR="${D}" install
	dodoc ChangeLog NEWS README
}
