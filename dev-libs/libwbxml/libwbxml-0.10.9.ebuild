# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libwbxml/libwbxml-0.10.9.ebuild,v 1.1 2011/03/19 20:24:35 scarabeus Exp $

EAPI=4

inherit cmake-utils

DESCRIPTION="Library and tools to parse, encode and handle WBXML documents."
HOMEPAGE="http://libwbxml.opensync.org/"
SRC_URI="mirror://sourceforge/libwbxml/${P}.tar.bz2"
KEYWORDS="~amd64 ~ppc ~x86"

IUSE="test"
LICENSE="GPL-2"
SLOT="0"

DEPEND="
	dev-libs/expat
	virtual/libiconv
	test? ( dev-libs/check )
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_enable test UNIT_TEST)
		"-DDOC_INSTALL_DIR=${EPREFIX}/usr/share/${PF}"
	)

	cmake-utils_src_configure
}
