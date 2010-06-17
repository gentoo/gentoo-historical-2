# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-geosciences/qgis/qgis-1.4.0-r1.ebuild,v 1.2 2010/06/17 21:07:26 patrick Exp $

EAPI="2"

PYTHON_USE_WITH="sqlite"
PYTHON_DEPEND="python? 2"
inherit python cmake-utils eutils

DESCRIPTION="User friendly Geographic Information System"
HOMEPAGE="http://www.qgis.org/"

SRC_URI="http://download.osgeo.org/${PN}/src/${PN}_${PV}.tar.gz
	examples? ( http://download.osgeo.org/qgis/data/qgis_sample_data.tar.gz )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples gps grass gsl postgres python sqlite"

RDEPEND=">=sci-libs/gdal-1.6.1
	x11-libs/qt-core:4[qt3support]
	x11-libs/qt-gui:4
	x11-libs/qt-svg:4
	x11-libs/qt-sql:4
	x11-libs/qt-webkit:4
	sci-libs/geos
	sci-libs/proj
	gps? (
		dev-libs/expat
		sci-geosciences/gpsbabel
	)
	grass? (
		>=sci-geosciences/grass-6.4.0_rc6
	)
	gsl? ( sci-libs/gsl )
	postgres? ( >=dev-db/postgresql-base-8 )
	python? ( dev-python/PyQt4[sql,svg] )
	sqlite? ( dev-db/sqlite:3 )"

DEPEND="${RDEPEND}
	sys-devel/bison
	sys-devel/flex"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-gcc45.patch
}

src_configure() {
	local mycmakeargs
	mycmakeargs+=(
		"-DQGIS_MANUAL_SUBDIR=/share/man/"
		"-DBUILD_SHARED_LIBS:BOOL=ON"
		"-DBINDINGS_GLOBAL_INSTALL:BOOL=ON"
		"-DQGIS_LIB_SUBDIR=$(get_libdir)"
		"-DQGIS_PLUGIN_SUBDIR=$(get_libdir)/qgis"
		$(cmake-utils_use_with postgres POSTGRESQL)
		$(cmake-utils_use_with grass)
		$(cmake-utils_use_with gps EXPAT)
		$(cmake-utils_use_with gsl)
		$(cmake-utils_use_with python BINDINGS)
		$(cmake-utils_use_with sqlite SPATIALITE)
	)
	use grass && mycmakeargs+=( "-DGRASS_PREFIX=/usr/" )

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	dodoc AUTHORS BUGS ChangeLog README SPONSORS CONTRIBUTORS || die

	newicon images/icons/qgis-icon.png qgis.png || die
	make_desktop_entry qgis "Quantum GIS " qgis

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins -r "${WORKDIR}"/qgis_sample_data/* || die "Unable to install examples"
	fi
}

pkg_postinst() {
	if use postgres; then
		elog "If you don't intend to use an external PostGIS server"
		elog "you should install:"
		elog "   dev-db/postgis"
	fi
}
