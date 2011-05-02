# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-geosciences/mapserver/mapserver-6.0.0_rc1.ebuild,v 1.6 2011/05/02 19:05:01 scarabeus Exp $

EAPI=3

MY_P="${PN}-${PV/_/-}"

PHP_EXT_NAME="php_mapscript"
PHP_EXT_S="${WORKDIR}/${MY_P}/mapscript/php/"
PHP_EXT_SKIP_PHPIZE="no"
USE_PHP="php5-3"

PYTHON_DEPEND="python? *"
SUPPORT_PYTHON_ABIS="1"
PYTHON_MODNAME="mapscript.py"

#USE_RUBY="ruby18 ruby19"
#RUBY_OPTIONAL="yes"

WEBAPP_MANUAL_SLOT=yes

inherit eutils autotools depend.apache webapp distutils perl-module php-ext-source-r2 # ruby-ng

DESCRIPTION="OpenSource development environment for constructing spatially enabled Internet-web applications."
HOMEPAGE="http://mapserver.org"
SRC_URI="http://download.osgeo.org/mapserver/${MY_P}.tar.gz"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"

# I must check for mygis use flag availability
IUSE="bidi cairo gdal geos gif mysql opengl perl php postgis proj python threads tiff xml xslt" # ruby php tcl

RDEPEND="
	dev-libs/expat
	dev-libs/fcgi
	>=media-libs/gd-2.0.12[truetype,jpeg,png,zlib]
	net-misc/curl
	virtual/jpeg
	virtual/libiconv
	x11-libs/agg
	bidi? ( dev-libs/fribidi )
	cairo? ( x11-libs/cairo )
	gdal? ( >=sci-libs/gdal-1.8.0 )
	geos? ( sci-libs/geos )
	gif? ( media-libs/giflib )
	mysql? ( virtual/mysql )
	opengl? (
		media-libs/ftgl
		media-libs/mesa
	)
	perl? ( dev-lang/perl )
	postgis? ( dev-db/postgis )
	proj? ( sci-libs/proj net-misc/curl )
	tiff? (
		media-libs/tiff
		sci-libs/libgeotiff
	)
	xml? ( dev-libs/libxml2:2 )
	xslt? ( dev-libs/libxslt[crypt] )
"
for i in perl python; do
	SWIG_DEPEND+=" ${i}? ( >=dev-lang/swig-2.0 )"
done
DEPEND="${RDEPEND} ${SWIG_DEPEND}"
unset SWIG_DEPEND
unset i

need_apache2

S=${WORKDIR}/${MY_P}

_enter_build_dir() {
	[[ -z ${1} ]] && die "Missing path argument"
	local workdir=${1}
	shift
	[[ -z ${1} ]] && die "missing command argument"

	echo ">>> Running \"${@}\" in work directory \"${workdir}\""
	pushd "${workdir}" > /dev/null || die "Failed to enter directory"
	${@} || die
	popd > /dev/null
}

each_ruby_configure() { ${RUBY} extconf.rb || die ; }

pkg_setup() {
	webapp_pkg_setup
	use perl && perl-module_pkg_setup
	use python && python_pkg_setup
	#use ruby && ruby-ng_pkg_setup
}

src_unpack() {
	# unpack A and then copy the php thingies into workdir/php-slot
	php-ext-source-r2_src_unpack
}

src_prepare() {
	epatch "${FILESDIR}/6.0.0_rc1-ldflags.patch"
	eautoreconf
}

src_configure() {
	local myopts

	if use gdal && use proj ; then
		myopts+="
			--with-wfs
			--with-wcs
			--with-wfsclient
			--with-wmsclient
		"
		use xml && myopts+=" --with-sos"
	fi

	# some scripts require configure time options so place it here
	use php && myopts+=" --with-php=${EPREFIX}/usr/lib64/php5.3/include/php/"

	# sde is ESRI package that you have to buy first
	# oraclespatial needs oracle server for testing/usage
	# note that some options accept just path, they are not on/off switches!
	econf \
		--without-oraclespatial \
		--without-sde \
		--with-libiconv \
		--with-jpeg \
		--with-gd \
		--with-wms \
		--with-kml \
		--with-curl-config \
		--with-agg-svg-symbols \
		--with-httpd="${APACHE_BIN}" \
		--with-fastcgi \
		$(use_with opengl ogl) \
		$(use_with opengl ftgl) \
		$(use_with gif gif "${EPREFIX}/usr/") \
		$(use_with proj) \
		$(use_with threads) \
		$(use_with geos) \
		$(use_with gdal) \
		$(use_with gdal ogr) \
		$(use_with postgis) \
		$(use_with mysql) \
		$(use_with xml xml2-config) \
		$(use_with xslt) \
		$(use_with xslt xml-mapfile) \
		$(use_with bidi fribidi-config) \
		$(use_with cairo) \
		${myopts}

	#use ruby && _enter_build_dir "${S}/mapscript/ruby" "ln -s ../mapscript.i ./"
	#use ruby && _enter_build_dir "${S}/mapscript/ruby" "ruby-ng_src_configure"
}

src_compile() {
	emake -j1 || die
	use python && _enter_build_dir "${S}/mapscript/python" "distutils_src_compile"
	use perl && _enter_build_dir "${S}/mapscript/perl" "perl-module_src_prep"
	use perl && _enter_build_dir "${S}/mapscript/perl" "perl-module_src_compile"
	use php && php-ext-source-r2_src_compile
	#use ruby && _enter_build_dir "${S}/mapscript/ruby" "ruby-ng_src_compile"
}

src_install() {
	local step="Installing"
	local extra_dir="fonts tests tests/vera symbols"
	local i

	dobin shp2img legend shptree shptreevis shp2img legend shptreetst scalebar \
		sortshp tile4ms msencrypt mapserver-config

	dodoc INSTALL README HISTORY.TXT

	for i in ${extra_dir}; do
		docinto /usr/share/doc/${PF}/${i}
		dodoc ${i}/* || die
	done

	use python && _enter_build_dir "${S}/mapscript/python" "distutils_src_install"
	use perl && _enter_build_dir "${S}/mapscript/perl" "perl-module_src_install"
	use perl && _enter_build_dir "${S}/mapscript/perl" "fixlocalpod"
	use php && php-ext-source-r2_src_install
	#use ruby && _enter_build_dir "${S}/mapscript/ruby" "ruby-ng_src_install"

	webapp_src_preinst
	exeinto "${MY_CGIBINDIR}"
	doexe "${S}/mapserv"
	webapp_src_install
}

pkg_preinst() {
	use perl && perl-module_pkg_preinst
}

pkg_postinst() {
	webapp_pkg_postinst
	use python && distutils_pkg_postinst
	use perl && perl-module_pkg_postinst
}

pkg_prerm() {
	webapp_pkg_prerm
	use perl && perl-module_pkg_prerm
}

pkg_postrm() {
	use python && distutils_pkg_postrm
	use perl && perl-module_pkg_postrm
}
