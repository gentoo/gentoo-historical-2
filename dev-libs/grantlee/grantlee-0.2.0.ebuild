# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/grantlee/grantlee-0.2.0.ebuild,v 1.3 2012/11/23 18:24:34 ago Exp $

EAPI=4

QT_MINIMAL="4.5.0"
inherit cmake-utils

DESCRIPTION="C++ string template engine based on the Django template system"
HOMEPAGE="http://www.gitorious.org/grantlee/pages/Home"
SRC_URI="http://www.loegria.net/grantlee/${P}.tar.gz"

LICENSE="LGPL-2.1"
KEYWORDS="amd64 ~arm ~ppc ~ppc64 x86"
SLOT="0"
IUSE="debug doc test"

COMMON_DEPEND="
	>=x11-libs/qt-core-${QT_MINIMAL}:4
	>=x11-libs/qt-gui-${QT_MINIMAL}:4
	>=x11-libs/qt-script-${QT_MINIMAL}:4
"
DEPEND="${COMMON_DEPEND}
	doc? ( || ( <app-doc/doxygen-1.7.6.1[-nodot] >=app-doc/doxygen-1.7.6.1[dot] ) )
	test? ( >=x11-libs/qt-test-${QT_MINIMAL}:4 )
"
RDEPEND="${COMMON_DEPEND}"

DOCS=(AUTHORS CHANGELOG GOALS README)

# Some tests fail
RESTRICT="test"

PATCHES=( "${FILESDIR}/${PN}-0.1.9-qt-test-optional.patch" )

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use_build test TESTS)
	)

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile

	use doc && cmake-utils_src_compile docs
}

src_install() {
	use doc && HTML_DOCS=("${CMAKE_BUILD_DIR}/apidox/")

	cmake-utils_src_install
}
