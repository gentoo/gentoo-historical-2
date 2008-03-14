# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/ibpp/ibpp-2.5.3.1.ebuild,v 1.2 2008/03/14 11:10:18 phreak Exp $

inherit eutils

MY_P=${P//./-}-src

DESCRIPTION="IBPP, a C++ client API for firebird 1.0"
HOMEPAGE="http://www.ibpp.org/"
SRC_URI="mirror://sourceforge/ibpp/${MY_P}.zip"

LICENSE="MPL-1.1"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

S="${WORKDIR}"

RDEPEND=">=dev-db/firebird-1.5.1"
DEPEND="${RDEPEND}
	app-arch/unzip"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/${P}-gentoo.patch
}

src_compile() {
	sh autogen.sh

	econf || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed."
}
