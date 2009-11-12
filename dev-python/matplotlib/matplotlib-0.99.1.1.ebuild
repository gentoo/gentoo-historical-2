# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/matplotlib/matplotlib-0.99.1.1.ebuild,v 1.8 2009/11/12 19:14:40 bicatali Exp $

WX_GTK_VER=2.8
EAPI=2
inherit distutils wxwidgets

PDOC="users_guide_${PV}"

DESCRIPTION="Pure python plotting library with matlab like syntax"
HOMEPAGE="http://matplotlib.sourceforge.net/ http://pypi.python.org/pypi/matplotlib"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

IUSE="cairo doc excel examples fltk gtk latex qt3 qt4 traits tk wxwidgets"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
LICENSE="PYTHON BSD"

CDEPEND=">=dev-python/numpy-1.1
	dev-python/python-dateutil
	dev-python/pytz
	media-libs/freetype:2
	media-libs/libpng
	gtk? ( dev-python/pygtk )
	tk? ( dev-lang/python[tk] )
	wxwidgets? ( dev-python/wxpython:2.8 )"

DEPEND="${CDEPEND}
	dev-python/pycxx
	dev-util/pkgconfig
	doc? (
		>=dev-python/sphinx-0.5.1
		|| (
			>=media-gfx/graphviz-2.24.0[cairo]
			<media-gfx/graphviz-2.24.0[cairo,png]
		)
		|| ( ( dev-texlive/texlive-latexextra
			   dev-texlive/texlive-latexrecommended )
			 ( app-text/ptex dev-tex/latex-unicode ) )
		app-text/dvipng
		dev-python/imaging
		dev-python/ipython )"

RDEPEND="${CDEPEND}
	|| ( media-fonts/dejavu media-fonts/ttf-bitstream-vera )
	media-fonts/texcm-ttf
	cairo?  ( dev-python/pycairo )
	excel?  ( dev-python/xlwt )
	fltk?   ( dev-python/pyfltk )
	qt3?    ( dev-python/PyQt )
	qt4?    ( dev-python/PyQt4[X] )
	traits? ( dev-python/traits dev-python/configobj )
	latex?  (
		virtual/latex-base
		virtual/ghostscript
		app-text/dvipng
		virtual/poppler-utils
		|| ( dev-texlive/texlive-fontsrecommended
			 app-text/ptex ) )"

DOCS="INTERACTIVE"

use_setup() {
	local uword="${2}"
	[ -z "${2}" ] && uword="${1}"
	if use ${1}; then
		echo "${uword} = True"
		echo "${uword}agg = True"
	else
		echo "${uword} = False"
		echo "${uword}agg = False"
	fi
}

src_prepare() {
	# avoid to launch xv while building examples docs
	epatch "${FILESDIR}"/${PN}-0.98.5.2-no-xv.patch

	# removes hardcoded lib paths, should not break non-Prefix, more
	# likely to fix it in case of multilib
	epatch "${FILESDIR}"/${P}-prefix.patch
	epatch "${FILESDIR}"/${PN}-0.99.0-freebsd7+.patch

	# create setup.cfg (see setup.cfg.template for any changes)
	cat > setup.cfg <<-EOF
		[provide_packages]
		pytz = False
		dateutil = False
		configobj = False
		enthought.traits = False
		[gui_support]
		$(use_setup gtk)
		$(use_setup tk)
		$(use_setup wxwidgets wx)
		$(use_setup qt3 qt)
		$(use_setup qt4)
		$(use_setup fltk)
		$(use_setup cairo)
	EOF

	# avoid checks needing a X display
	sed -i \
		-e "s/check_for_gtk()/$(use gtk && echo True || echo False)/" \
		-e "s/check_for_tk()/$(use tk && echo True || echo False)/" \
		setup.py || die "sed setup.py failed"

	# respect FHS:
	#  - mpl-data in /usr/share/matplotlib
	#  - config files in /etc/matplotlib
	sed -i \
		-e "/'mpl-data\/matplotlibrc',/d" \
		-e "/'mpl-data\/matplotlib.conf',/d" \
		-e "s:'lib/matplotlib/mpl-data/matplotlibrc':'matplotlibrc':" \
		-e "s:'lib/matplotlib/mpl-data/matplotlib.conf':'matplotlib.conf':" \
		setup.py \
		|| die "sed setup.py for FHS failed"

	sed -i \
		-e "s:path =  get_data_path():path = '${EPREFIX}/etc/matplotlib':" \
		-e "s:os.path.dirname(__file__):'${EPREFIX}/usr/share/${PN}':g"  \
		lib/matplotlib/{__init__,config/cutils}.py \
		|| die "sed init for FHS failed"

	# remove internal copies of fonts, pycxx, pyparsing
	rm -rf \
		CXX \
		lib/matplotlib/mpl-data/fonts/{afm,pdfcorefonts} \
		lib/matplotlib/mpl-data/fonts/ttf/{Vera*,cm*,*.TXT} \
		|| die "removed internal copies failed"
	python_version
	ln -s "${EPREFIX}"/usr/share/python${PYVER}/CXX . || die

	# remove pyparsing only when upstream pyparsing included matplotlib
	# fixes. See bug #260025
	#rm -f lib/matplotlib/pyparsing.py
}

src_compile() {
	unset DISPLAY # bug #278524
	distutils_src_compile
	if use doc; then
		cd "${S}/doc"
		export VARTEXFONTS="${T}"/fonts
		# no die function here: broken compilation at the end, do it twice,
		# result ok.
		MATPLOTLIBDATA="${S}/lib/matplotlib/mpl-data" \
			PYTHONPATH=$(dir -d "${S}"/build/lib*) \
			${python} make.py html
		MATPLOTLIBDATA="${S}/lib/matplotlib/mpl-data" \
			PYTHONPATH=$(dir -d "${S}"/build/lib*) \
			${python} make.py
	fi
}

src_test() {
	einfo "Tests are quite long, be patient"
	cd "${S}/examples/tests"
	PYTHONPATH=$(dir -d "${S}"/build/lib*) ${python} backend_driver.py agg \
		|| die "tests failed"
	PYTHONPATH=$(dir -d "${S}"/build/lib*) ${python} backend_driver.py \
		--clean
}

src_install() {
	[[ -z ${ED} ]] && local ED=${D}
	distutils_src_install

	# respect FHS
	dodir /usr/share/${PN}
	mv "${ED}"/usr/*/*/site-packages/${PN}/{mpl-data,backends/Matplotlib.nib} \
		"${ED}"/usr/share/${PN} || die "failed renaming"
	insinto /etc/matplotlib
	doins matplotlibrc matplotlib.conf \
		|| die "installing config files failed"

	# doc and examples
	insinto /usr/share/doc/${PF}
	if use doc; then
		doins doc/build/latex/Matplotlib.pdf || die
		doins -r doc/build/html || die
	fi
	if use examples; then
		doins -r examples || die
	fi
}
