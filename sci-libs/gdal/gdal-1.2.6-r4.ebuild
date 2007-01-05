# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/gdal/gdal-1.2.6-r4.ebuild,v 1.13 2007/01/05 09:08:46 flameeyes Exp $

inherit eutils libtool distutils toolchain-funcs

IUSE="jpeg png geos gif jpeg2k netcdf hdf python postgres mysql sqlite \
	odbc ogdi fits gml doc debug"

DESCRIPTION="GDAL is a translator library for raster geospatial data formats (includes OGR support)"
HOMEPAGE="http://www.remotesensing.org/gdal/index.html"
SRC_URI="http://dl.maptools.org/dl/gdal/${P}.tar.gz"

SLOT="0"
LICENSE="MIT"
KEYWORDS="amd64 ppc sparc x86"
# need to get these arches updated on several libs first
#KEYWORDS="~alpha ~hppa ~ppc64"

DEPEND=">=sys-libs/zlib-1.1.4
	>=media-libs/tiff-3.7.0
	sci-libs/libgeotiff
	jpeg? ( media-libs/jpeg )
	gif? ( media-libs/giflib )
	png? ( media-libs/libpng )
	python? ( dev-lang/python )
	fits? ( sci-libs/cfitsio )
	ogdi? ( sci-libs/ogdi )
	gml? ( dev-libs/xerces-c )
	|| (
	    postgres? ( dev-db/postgresql )
	    mysql? ( virtual/mysql )
	)
	|| (
	    netcdf? ( sci-libs/netcdf )
	    hdf? ( sci-libs/hdf )
	)
	jpeg2k? ( media-libs/jasper )
	odbc?   ( dev-db/unixODBC )
	geos?   ( sci-libs/geos )
	sqlite? ( >=dev-db/sqlite-3 )
	doc? ( app-doc/doxygen )"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${P}-installpathfix.patch || die "epatch failed"
	if [ $(gcc-major-version) -eq 4 ] ; then
	    epatch ${FILESDIR}/${PN}-gcc4.patch || die "gcc4 patch failed"
	fi
	elibtoolize --patch-only
	if useq netcdf && useq hdf; then
	    einfo	"Checking is HDF4 compiled with szip..."
	    if built_with_use sci-libs/hdf szip ; then
		einfo	"Found HDF4 compiled with szip. Nice."
	    else
		ewarn 	"HDF4 (sci-libs/hdf) must be compiled with szip USE flag!"
		einfo   "Emerge HDF with szip USE flag and then emerge GDAL."
		die 	"HDF4 not merged with szip use flag"
	    fi
	fi
}

src_compile() {
	distutils_python_version

	pkg_conf="--enable-static=no --enable-shared=yes --with-gnu-ld"

	use_conf="$(use_with jpeg) $(use_with png) $(use_with mysql) \
	    $(use_with postgres pg) $(use_with fits cfitsio) \
	    $(use_with netcdf) $(use_with hdf hdf4) $(use_with geos) \
	    $(use_with sqlite) $(use_with jpeg2k jasper) $(use_with odbc) \
	    $(use_with gml xerces)"

	# It can't find this
	if useq ogdi ; then
	    use_conf="--with-ogdi=/usr/$(get_libdir) ${use_conf}"
	fi

	if useq gif ; then
	    use_conf="--with-gif=internal ${use_conf}"
	else
	    use_conf="--with-gif=no ${use_conf}"
	fi

	if useq debug ; then
	    export CFG=debug
	fi

	if useq python ; then
	    use_conf="--with-pymoddir=/usr/$(get_libdir)/python${PYVER}/site-packages \
	    ${use_conf}"
	else
	    use_conf="--with-python=no ${use_conf}"
	fi

	# Fix doc path just in case
	sed -i -e "s:@exec_prefix@/doc:${D}usr/share/doc/${PF}/html:g" GDALmake.opt.in

	econf ${pkg_conf} ${use_conf} || die "econf failed"
	emake  || die "emake failed"
	if useq doc ; then
	    emake docs || die "emake docs failed"
	fi
}

src_install() {
	# einstall causes sandbox violations on /usr/lib/libgdal.so
	make DESTDIR=${D} install || die "make install failed"
	dodoc Doxyfile.man Doxyfile HOWTO-RELEASE NEWS
	if useq doc ; then
	    dohtml html/* || die "install html failed"
	    docinto ogr
	    dohtml ogr/html/* || die "install ogr html failed"
	fi
}

pkg_postinst() {
	einfo "GDAL is most useful with full graphics support enabled via various"
	einfo "USE flags: png, jpeg, gif, jpeg2k, etc. Also python, fits, ogdi,"
	einfo "geos, and support for either netcdf or HDF4 is available, as well as"
	einfo "grass, and mysql, sqlite, or postgres (grass support requires newer"
	einfo "gdal and gdal-grass)."
	ewarn
	einfo "Note: tiff and geotiff are now hard depends, so no USE flags."
	einfo "Also, this package will check for netcdf before hdf, so if you"
	einfo "prefer hdf, please emerge hdf with USE=szip prior to emerging"
	einfo "gdal.  Detailed API docs require doxygen (man pages are free)."
	einfo ""
	einfo "Check available image and data formats after building with"
	einfo "gdalinfo and ogrinfo (using the --formats switch)."
}

