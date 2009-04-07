# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/lasi/lasi-1.1.0-r1.ebuild,v 1.3 2009/04/07 19:46:49 klausman Exp $

EAPI=2
inherit eutils cmake-utils

MY_PN="libLASi"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="C++ library for postscript stream output"
HOMEPAGE="http://www.unifont.org/lasi/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~x86"
IUSE="doc examples"

RDEPEND="x11-libs/pango
	media-libs/freetype:2"

DEPEND="${RDEPEND}
	dev-util/pkgconfig
	doc? ( app-doc/doxygen )"

S="${WORKDIR}/${MY_P}"

DOCS="AUTHORS NEWS NOTES README"

src_prepare() {
	epatch "${FILESDIR}"/${P}-cmake.patch
	sed -i \
		-e "s:\/lib$:\/$(get_libdir):" \
		-e "s/libLASi-\${VERSION}/${PF}/" \
		cmake/modules/instdirs.cmake \
		|| die "Failed to fix cmake module"
	sed -i \
		-e "s:\${DATA_DIR}/examples:/usr/share/doc/${PF}/examples:" \
		examples/CMakeLists.txt || die

	use examples || sed -i -e '/add_subdirectory(examples)/d' CMakeLists.txt
}

src_configure() {
	CMAKE_BUILD_TYPE=None
	mycmakeargs="${mycmakeargs}
		 -DCMAKE_SKIP_RPATH=OFF
		 -DUSE_RPATH=OFF"
		use doc || mycmakeargs="${mycmakeargs} -DDOXYGEN_EXECUTABLE="
	cmake-utils_src_configure
}
