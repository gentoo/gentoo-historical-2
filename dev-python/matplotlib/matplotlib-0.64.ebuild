# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/matplotlib/matplotlib-0.64.ebuild,v 1.3 2005/02/11 22:05:23 kloeri Exp $

inherit distutils virtualx

DESCRIPTION="matplotlib is a pure python plotting library designed to bring publication quality plotting to python with a syntax familiar to matlab users."
HOMEPAGE="http://matplotlib.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
RESTRICT="nomirror"

IUSE="gtk"
SLOT="0"
KEYWORDS="x86"
LICENSE="as-is"

DEPEND="virtual/python
		>=dev-python/numeric-22
		gtk? ( >=dev-python/pygtk-1.99.16 )"

src_compile() {
	export maketype="distutils_src_compile"
	virtualmake "$*"
}

src_install() {
	export maketype="distutils_src_install"
	virtualmake "$*"
	distutils_python_version

	# Setup examples
	insinto /usr/share/${PN}/examples
	doins examples/*.py examples/*.~1* examples/README
	insinto /usr/share/${PN}/examples/data
	doins examples/data/*.dat
}

