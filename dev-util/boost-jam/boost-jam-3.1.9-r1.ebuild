# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/boost-jam/boost-jam-3.1.9-r1.ebuild,v 1.2 2004/06/25 02:21:05 agriffis Exp $

IUSE=""

inherit eutils

DESCRIPTION="Boost.Jam - an alternative to make based on Jam."
HOMEPAGE="http://www.boost.org/tools/build/jam_src/index.html"
SRC_URI="mirror://sourceforge/boost/${P}.tgz"
RESTRICT="nomirror"

LICENSE="as-is"
SLOT="0"

KEYWORDS="~x86 ~ppc ~amd64"

DEPEND="dev-libs/boost
	!dev-util/jam"

src_unpack() {
	unpack ${A}

	cd ${S}
	epatch ${FILESDIR}/${P}-dir.patch
}

src_compile() {
	./build.sh
}

src_install() {
	dodoc boost-jam.spec Porting LICENSE_1_0.txt
	dohtml Jam.html

	cd ${S}/bin.linux${ARCH}
	dobin bjam jam mkjambase yyacc
}
