# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-cpp/libassa/libassa-3.5.1.ebuild,v 1.2 2012/05/26 20:32:44 angelos Exp $

EAPI=4
inherit eutils

DESCRIPTION="A networking library based on Adaptive Communication Patterns"
HOMEPAGE="http://libassa.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc static-libs"

RDEPEND="net-libs/libtirpc"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

DOCS=( AUTHORS ChangeLog NEWS README TODO )

src_prepare() {
	epatch "${FILESDIR}"/${PN}-3.5.0-fix-tests.patch
}

src_configure() {
	econf \
		$(use_enable static-libs static) \
		$(use_enable doc doxygen)
}

src_install() {
	default
	find "${ED}" -name "*.la" -exec rm -rf {} + || die "failed to delete .la files"
}
