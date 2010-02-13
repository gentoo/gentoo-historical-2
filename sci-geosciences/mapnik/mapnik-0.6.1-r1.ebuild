# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-geosciences/mapnik/mapnik-0.6.1-r1.ebuild,v 1.2 2010/02/13 05:37:07 nerdboy Exp $

EAPI=2

inherit eutils distutils toolchain-funcs

DESCRIPTION="A Free Toolkit for developing mapping applications."
HOMEPAGE="http://www.mapnik.org/"
SRC_URI="mirror://berlios/${PN}/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="cairo curl debug doc +gdal postgres python sqlite"

RDEPEND="=dev-libs/boost-1.39*
	dev-libs/libxml2
	dev-libs/icu
	media-libs/libpng
	media-libs/jpeg
	media-libs/tiff
	media-libs/freetype:2
	sci-libs/proj
	x11-libs/agg[gpc,truetype]
	media-fonts/dejavu
	python? ( =dev-libs/boost-1.39*[python] )
	cairo? ( x11-libs/cairo
		dev-cpp/cairomm )
	postgres? (
		>=virtual/postgresql-base-8.0
		>=dev-db/postgis-1.1.2
	)
	gdal? ( sci-libs/gdal )
	sqlite? ( dev-db/sqlite:3 )
	curl? ( net-misc/curl )"

DEPEND="${RDEPEND}
	>=dev-util/scons-1.0.0"

src_prepare() {
	sed -i -e "s|/usr/local|/usr|g" \
		-e "s|Action(env\[config\]|Action('%s --help' % env\[config\]|" \
		SConstruct || die

	sed -i -e "s:mapniklibpath + '/fonts':'/usr/share/fonts/dejavu/':g" \
	    bindings/python/SConscript || die "sed 1 failed"
	rm -rf agg
	epatch "${FILESDIR}"/${P}-libagg.patch
}

src_configure() {
	MAKEOPTS="SYSTEM_FONTS=/usr/share/fonts/dejavu"

	MAKEOPTS="${MAKEOPTS} INPUT_PLUGINS="
	use postgres && MAKEOPTS="${MAKEOPTS}postgis,"
	use gdal     && MAKEOPTS="${MAKEOPTS}gdal,ogr,"
	use sqlite   && MAKEOPTS="${MAKEOPTS}sqlite,"
	use curl     && MAKEOPTS="${MAKEOPTS}osm,"
	MAKEOPTS="${MAKEOPTS}shape,raster"

	use cairo  || MAKEOPTS="${MAKEOPTS} CAIRO=false"
	use python || MAKEOPTS="${MAKEOPTS} BINDINGS=none"
	use debug  && MAKEOPTS="${MAKEOPTS} DEBUG=yes"

	use postgres && use sqlite && MAKEOPTS="${MAKEOPTS} PGSQL2SQLITE=yes"

	scons CXX="$(tc-getCXX)" ${MAKEOPTS} DESTDIR="${D}" configure \
	    || die "scons configure failed"
}

src_compile() {
	scons || die "scons make failed"
}

src_install() {
	scons install || die "scons install failed"

	if use python ; then
	    distutils_python_version
	    fperms 0755 /usr/$(get_libdir)/python${PYVER}/site-packages/mapnik/paths.py
	    dobin utils/stats/mapdef_stats.py
	    insinto /usr/share/doc/${P}/examples
	    doins utils/ogcserver/*
	fi

	dodoc AUTHORS CHANGELOG README
	use doc && dohtml -r docs/api_docs/python/*
}

pkg_postinst() {
	elog ""
	elog "See the home page or the OpenStreetMap wiki for more info, and"
	elog "the installed examples for the default mapnik ogcserver config."
	elog ""
}
