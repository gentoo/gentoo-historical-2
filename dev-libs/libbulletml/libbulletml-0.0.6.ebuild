# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libbulletml/libbulletml-0.0.6.ebuild,v 1.1 2004/09/27 06:55:07 mr_bones_ Exp $

DESCRIPTION="A Library of Bullet Markup Language"
HOMEPAGE="http://user.ecc.u-tokyo.ac.jp/~s31552/wp/libbulletml/index_en.html"
SRC_URI="http://user.ecc.u-tokyo.ac.jp/~s31552/wp/libbulletml/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="x86"
IUSE=""

S="${WORKDIR}/${PN#lib}/src"

src_compile() {
	emake CFLAGS="${CFLAGS}" CXXFLAGS="${CXXFLAGS}" || die "emake failed"
}

src_install() {
	dolib.a libbulletml.a

	insinto /usr/include/bulletml
	doins *.h

	insinto /usr/include/bulletml/tinyxml
	doins tinyxml/tinyxml.h

	insinto /usr/include/bulletml/ygg
	doins ygg/ygg.h

	dodoc ../README*
}
