# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/basemap/basemap-0.9.6.ebuild,v 1.1 2007/11/03 19:06:53 bicatali Exp $

inherit distutils

DESCRIPTION="matplotlib toolkit to plot map projections"
HOMEPAGE="http://matplotlib.sourceforge.net/matplotlib.toolkits.basemap.basemap.html"
SRC_URI="mirror://sourceforge/matplotlib/${P}.tar.gz"

IUSE="examples"
SLOT="0"
KEYWORDS="~amd64 ~x86"
LICENSE="MIT GPL-2"
RESTRICT="test"

DEPEND="sci-libs/shapelib
	sci-libs/proj"

RDEPEND="${DEPEND}
	dev-python/numpy
	>=dev-python/matplotlib-0.90"

DOCS="FAQ API_CHANGES"

src_unpack() {
	unpack ${A}
	cd "${S}"
	# patch to use proj and shapelib system libraries
	epatch "${FILESDIR}"/${P}-syslib.patch
}

src_install() {
	distutils_src_install
	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins examples/* || die
	fi
}
