# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-geosciences/qgis/qgis-1.3.0.ebuild,v 1.3 2009/12/15 10:59:40 scarabeus Exp $

EAPI="2"

inherit cmake-utils eutils

DESCRIPTION="User friendly Geographic Information System"
HOMEPAGE="http://www.qgis.org/"
SRC_URI="http://download.osgeo.org/${PN}/src/${PN}_${PV}.tar.gz
	examples? ( http://download.osgeo.org/${PN}/data/${PN}_sample_data.tar.gz )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples gps grass gsl postgres python sqlite"

RDEPEND=">=sci-libs/gdal-1.6.1
	x11-libs/qt-core:4[qt3support]
	x11-libs/qt-gui:4
	x11-libs/qt-svg:4
	x11-libs/qt-sql:4
	sci-libs/geos
	sci-libs/proj
	gps? ( dev-libs/expat sci-geosciences/gpsbabel )
	grass? ( >=sci-geosciences/grass-6 sci-geosciences/gdal-grass )
	gsl? ( sci-libs/gsl )
	postgres? ( >=virtual/postgresql-base-8 )
	python? ( dev-python/PyQt4[sql,svg] )
	sqlite? ( dev-db/sqlite:3 )"

DEPEND="${RDEPEND}
	sys-devel/bison
	sys-devel/flex"

src_prepare() {
	# patch to wor with all versions of sip, taken from upstream trunk
	epatch "${FILESDIR}"/${P}-sip.patch
}

src_configure() {
	local mycmakeargs
	mycmakeargs+=(
		"-DBUILD_SHARED_LIBS:BOOL=ON"
		"-DBINDINGS_GLOBAL_INSTALL:BOOL=ON"
		"-DQGIS_LIB_SUBDIR=$(get_libdir)"
		"-DQGIS_PLUGIN_SUBDIR=$(get_libdir)/qgis"
		$(cmake-utils_use_with postgres POSTGRESQL)
		$(cmake-utils_use_with grass GRASS)
		$(cmake-utils_use_with gps EXPAT)
		$(cmake-utils_use_with gsl GSL)
		$(cmake-utils_use_with python BINDINGS)
		$(cmake-utils_use_with sqlite SPATIALITE)
	)

	if use grass; then
		GRASS_ENVD="/etc/env.d/99grass /etc/env.d/99grass-6 /etc/env.d/99grass-cvs";
		for file in ${GRASS_ENVD}; do
			if test -r ${file}; then
				GRASSPATH=$(sed -n 's/LDPATH="\(.*\)\/lib"$/\1/p' ${file});
			fi
		done
		mycmakeargs+=(
			"-DGRASS_PREFIX=${GRASSPATH}"
		)
	fi
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	dodoc AUTHORS BUGS ChangeLog README SPONSORS CONTRIBUTORS

	newicon images/icons/qgis-icon.png qgis.png
	make_desktop_entry qgis "Quantum GIS " qgis.png

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins "${WORKDIR}"/qgis_sample_data/* || die "Unable to install examples"
	fi
}

pkg_postinst() {
	if use postgres; then
		elog "If you don't intend to use external PostGIS server"
		elog "you should install:"
		elog "   dev-db/postgis"
	fi
}
