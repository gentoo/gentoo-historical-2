# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/matplotlib/matplotlib-0.91.1.ebuild,v 1.1 2007/12/07 11:29:28 bicatali Exp $

NEED_PYTHON=2.3

inherit distutils

DOC_PV=${PV}

DESCRIPTION="Pure python plotting library with matlab like syntax"
HOMEPAGE="http://matplotlib.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz
	doc? ( http://matplotlib.sourceforge.net/users_guide_${DOC_PV}.pdf )"

IUSE="cairo doc examples fltk gtk latex qt3 qt4 tk wxwindows"
SLOT="0"
KEYWORDS="~amd64 ~x86"
LICENSE="PYTHON BSD stix bakoma"

DEPEND="dev-python/numpy
	>=media-libs/freetype-2
	media-libs/libpng
	dev-python/pytz
	dev-python/python-dateutil
	gtk? ( dev-python/pygtk )
	wxwindows? ( dev-python/wxpython )"

RDEPEND="${DEPEND}
	media-fonts/ttf-bitstream-vera
	latex? ( virtual/latex-base
		virtual/ghostscript
		app-text/dvipng
		app-text/poppler )
	cairo? ( dev-python/pycairo )
	fltk?  ( dev-python/pyfltk )
	qt3?   ( dev-python/PyQt )
	qt4?   ( dev-python/PyQt4 )"

DOCS="INTERACTIVE API_CHANGES"

pkg_setup() {
	use tk && distutils_python_tkinter
}

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

src_unpack() {
	unpack ${A}
	cd "${S}"

	# create setup.cfg (see setup.cfg.template for any changes)
	{
		echo "[provide_packages]"
		echo "pytz = False"
		echo "dateutil = False"
		echo "configobj = False"
		echo "enthought.traits = False"
		echo "[gui_support]"
		use_setup gtk
		use_setup tk
		use_setup wxwindows wx
		use_setup qt3 qt
		use_setup qt4
		use_setup fltk
		use_setup cairo
	} > setup.cfg

	# sed to avoid checks needing a X display
	sed -i \
		-e "s/check_for_gtk()/$(use gtk && echo True || echo False)/" \
		-e "s/check_for_tk()/$(use tk && echo True || echo False)/" \
		setup.py || die "sed setup.py failed"

	# respect FHS: put mpl-data in /usr/share/matplotlib
	# and config files in /etc/matplotlib
	sed -i \
		-e "/'mpl-data\/matplotlibrc',/d" \
		-e "/'mpl-data\/matplotlib.conf',/d" \
		-e "s:'lib/matplotlib/mpl-data/matplotlibrc':'matplotlibrc':" \
		-e "s:'lib/matplotlib/mpl-data/matplotlib.conf':'matplotlib.conf':" \
		setup.py \
		|| die "sed setup.py for FHS failed"

	sed -i \
		-e "s:path =  get_data_path():path = '/etc/matplotlib':" \
		-e "s:os.path.dirname(__file__):'/usr/share/${PN}':g"  \
		lib/matplotlib/{__init__,config/cutils}.py \
		|| die "sed init for FHS failed"

	# cleaning and remove vera fonts (they are now a dependency)
	find -name .cvsignore -exec rm -rf {} \;
	cd lib/matplotlib/mpl-data
	rm -f ttf/Vera*.ttf ttf/*.TXT ttf/local.conf pdfcorefonts/readme.txt
}

src_install() {
	distutils_src_install

	# respect FHS
	dodir /usr/share/${PN}
	mv "${D}"/usr/*/*/site-packages/${PN}/{mpl-data,backends/Matplotlib.nib} "${D}"/usr/share/${PN}

	insinto /etc/matplotlib
	doins matplotlibrc matplotlib.conf \
		|| die "installing config files failed"

	insinto /usr/share/doc/${PF}
	use doc && doins "${DISTDIR}"/users_guide_${DOC_PV}.pdf
	use examples && doins -r examples
}
