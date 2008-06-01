# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-benchmarks/acovea/acovea-5.1.1.ebuild,v 1.3 2008/06/01 16:58:14 pchrist Exp $

inherit autotools

DESCRIPTION="Analysis of Compiler Options via Evolutionary Algorithm"
HOMEPAGE="http://www.coyotegulch.com/products/acovea/"
SRC_URI="http://www.coyotegulch.com/distfiles/lib${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND=">=dev-libs/libcoyotl-3.1.0
	>=dev-libs/libevocosm-3.1.0
	dev-libs/expat"
DEPEND="${RDEPEND}"

S=${WORKDIR}/lib${P}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-asneeded.patch
	epatch "${FILESDIR}"/${P}-free-fix.patch
	if has_version ">=libevocosm-3.3.0" ; then
		epatch ${FILESDIR}"/${P}-libevocosm.patch"
	fi
	eautomake
}

src_install() {
	make DESTDIR="${D}" install
	dodoc ChangeLog NEWS README
}
