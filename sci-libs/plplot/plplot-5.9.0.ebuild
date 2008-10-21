# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/plplot/plplot-5.9.0.ebuild,v 1.1 2008/10/21 11:49:25 bicatali Exp $

EAPI="2"
WX_GTK_VER="2.8"
inherit eutils fortran cmake-utils wxwidgets java-pkg-opt-2

DESCRIPTION="Multi-language scientific plotting library"
HOMEPAGE="http://plplot.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ada doc examples fortran fortran95 gd gnome java jpeg gif latex
	octave pdf perl png python qhull svga tcl threads tk truetype wxwindows X"

RDEPEND="ada? ( virtual/gnat )
	java? ( >=virtual/jre-1.5 )
	gd? ( media-libs/gd[jpeg?,png?] )
	gnome? ( gnome-base/libgnomeui
			 gnome-base/libgnomeprintui
			 python? ( dev-python/gnome-python ) )
	latex? ( virtual/latex-base virtual/ghostscript )
	octave? ( >=sci-mathematics/octave-3 )
	pdf? ( media-libs/libharu )
	perl? ( dev-perl/PDL dev-perl/XML-DOM )
	python? ( dev-python/numpy )
	svga? ( media-libs/svgalib )
	tcl? ( dev-lang/tcl dev-tcltk/itcl )
	tk? ( dev-lang/tk dev-tcltk/itk )
	truetype? ( media-libs/freetype
				media-fonts/freefont-ttf
				media-libs/lasi
				gd? ( media-libs/gd[truetype] ) )
	wxwindows? ( x11-libs/wxGTK:2.8[X] x11-libs/agg )
	X? ( x11-libs/libX11 x11-libs/libXau x11-libs/libXdmcp )"


DEPEND="${RDEPEND}
	dev-util/pkgconfig
	doc? ( app-text/opensp
		   app-text/jadetex
		   app-text/docbook2X
		   app-text/docbook-dsssl-stylesheets
		   dev-perl/XML-DOM
		   virtual/latex-base
		   virtual/ghostscript
		   sys-apps/texinfo )
	java? ( >=virtual/jdk-1.5 dev-lang/swig )
	python? ( dev-lang/swig )
	qhull? ( media-libs/qhull )"

pkg_setup() {
	FORTRAN="gfortran ifc g77"
	use fortran95 && FORTRAN="gfortran ifc"
	if use fortran || use fortran95; then
		fortran_pkg_setup
	fi
	export FC=${FORTRANC} F77=${FORTRANC}
}

src_prepare() {
	# from upstream svn
	epatch "${FILESDIR}"/${P}-cmake.patch
	# substitute EC.enc by ec.enc
	epatch "${FILESDIR}"/${P}-pdftex.patch
	# path for python independent of python version
	epatch "${FILESDIR}"/${P}-python.patch

	# remove license
	sed -i -e '/COPYING.LIB/d' CMakeLists.txt || die
	# change default install directories for doc and examples
	sed -i \
		-e 's:${DATA_DIR}/examples:${DOC_DIR}/examples:g' \
		{examples,test}/CMakeLists.txt examples/*/CMakeLists.txt || die
	sed -i \
		-e 's:${VERSION}::g' \
		-e "s:doc/\${PACKAGE}:doc/${PF}:" \
		cmake/modules/instdirs.cmake || die
	# haru pdf devide does not build with HPDF_SHARED
	sed -i \
		-e 's:-DHPDF_SHARED::' \
		cmake/modules/pdf.cmake || die

	# haru pdf devide does not build with HPDF_SHARED
	sed -i \
		-e 's:-DHPDF_SHARED::' \
		cmake/modules/pdf.cmake || die
	# default location for docbook crap
	sed -i \
		-e 's:xml/declaration:sgml:' \
		cmake/modules/docbook.cmake || die

	if use wxwindows; then
		WX_COMPILE=$(${WX_CONFIG} --cxxflags)
		WX_LIBS=$(${WX_CONFIG} --libs)
		sed -i \
			-e "s:-I\${wxWidgets_INCLUDE_DIRS} \${wxWidgets_DEFINITIONS}:${WX_COMPILE}:" \
			-e "s:\${wxWidgets_LIBRARIES}:\"${WX_LIBS}\":" \
			cmake/modules/wxwidgets.cmake || die
	fi
}

src_configure() {
	# see http://www.miscdebris.net/plplot_wiki/index.php?title=CMake_options_for_PLplot

	cmake-utils_pld() { _use_me_now PLD "$@" ; }

	# optional ones
	mycmakeargs="-DDEFAULT_ALL_DEVICES=ON
		$(cmake-utils_has python numpy)
		$(cmake-utils_has qhull QHULL)
		$(cmake-utils_has threads PTHREAD)
		$(cmake-utils_has truetype FREETYPE)
		$(cmake-utils_use_enable ada ada)
		$(cmake-utils_use_enable fortran f77)
		$(cmake-utils_use_enable fortran95 f95)
		$(cmake-utils_use_enable java java)
		$(cmake-utils_use_enable gnome gnome2)
		$(cmake-utils_use_enable octave octave)
		$(cmake-utils_use_enable perl pdl)
		$(cmake-utils_use_enable python python)
		$(cmake-utils_use_enable tcl tcl)
		$(cmake-utils_use_enable tcl itcl)
		$(cmake-utils_use_enable tk tk)
		$(cmake-utils_use_enable tk itk)
		$(cmake-utils_use_enable wxwindows wxwidgets)
		$(cmake-utils_pld pdf pdf)
		$(cmake-utils_pld latex pstex)
		$(cmake-utils_pld svga linuxvga)"

	use truetype && mycmakeargs="${mycmakeargs}
		-DPL_FREETYPE_FONT_PATH:PATH=/usr/share/fonts/freefont-ttf"

	if use python && use gnome; then
		mycmakeargs="${mycmakeargs}	-DENABLE_pygcw=ON"
	else
		mycmakeargs="${mycmakeargs}	-DENABLE_pygcw=OFF"
	fi
	cmake-utils_src_configure
}

src_compile() {
	# separate doc and normal because doc building crashes with parallel
	cmake-utils_src_make
	if use doc; then
		mycmakeargs="${mycmakeargs}	-DBUILD_DOC=ON"
		mycmakeargs="${mycmakeargs}	-DHAVE_DB_DTD=ON"
		mycmakeargs="${mycmakeargs}	-DHAVE_DSSSL_DTD=ON"
		mycmakeargs="${mycmakeargs}	-DHAVE_HTML_SS=ON"
		mycmakeargs="${mycmakeargs}	-DHAVE_PRINT_SS=ON"
		cmake-utils_src_configure
		cmake-utils_src_make -j1
	fi
}

src_install() {
	cmake-utils_src_install
	use examples || rm -rf "${D}"usr/share/doc/${PF}/examples
}
