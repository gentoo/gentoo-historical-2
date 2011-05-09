# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/marble/marble-4.6.2-r1.ebuild,v 1.2 2011/05/09 08:48:47 tomka Exp $

EAPI=3

KDE_HANDBOOK="optional"
KMNAME="kdeedu"
CPPUNIT_REQUIRED="optional"
PYTHON_DEPEND="python? 2"
inherit python kde4-meta

DESCRIPTION="Generic geographical map widget"
KEYWORDS="~amd64 ~ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="debug designer-plugin gps plasma python"

# tests fail / segfault. Last checked for 4.2.88
RESTRICT=test

DEPEND="
	gps? ( >=sci-geosciences/gpsd-2.95[qt4] )
	python? (
		>=dev-python/PyQt4-4.4.4-r1
		$(add_kdebase_dep pykde4)
	)
"
RDEPEND="${DEPEND}
	!kdeprefix? ( !sci-geosciences/marble )
"

PATCHES=( "${FILESDIR}/${PN}-4.6.2-magic.patch" )
# note that this patch will not work if we ever make a qt-only build

pkg_setup() {
	python_set_active_version 2
	kde4-meta_pkg_setup
}

src_prepare() {
	kde4-meta_src_prepare
	python_convert_shebangs -r $(python_get_version) .
}

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use_with designer-plugin DESIGNER_PLUGIN)
		$(cmake-utils_use_with plasma)
		$(cmake-utils_use python EXPERIMENTAL_PYTHON_BINDINGS)
		$(cmake-utils_use_with python PyKDE4)
		$(cmake-utils_use_with python PyQt4)
		$(cmake-utils_use_with python PythonLibrary)
		$(cmake-utils_use_with python SIP)
		$(cmake-utils_use_with gps libgps)
		-DWITH_liblocation=0
	)

	find "${S}/marble/src/bindings/python/sip" -name "*.sip" | xargs -- sed -i 's/#include <marble\//#include </'

	kde4-meta_src_configure
}

src_install() {
	if use plasma; then
		insinto "${KDEDIR}"/share/apps/cmake/modules
		doins "${S}"/cmake/modules/FindMarbleWidget.cmake
	fi
	kde4-meta_src_install
}
