# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/gnuplot-py/gnuplot-py-1.7.ebuild,v 1.5 2006/01/29 19:49:59 cryos Exp $

inherit distutils

DESCRIPTION="A python wrapper for Gnuplot"
HOMEPAGE="http://gnuplot-py.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ppc s390 x86"
IUSE=""

DEPEND="virtual/python
	sci-visualization/gnuplot
	dev-python/numeric"

src_install() {
	distutils_src_install
	dohtml doc/Gnuplot/*
	insinto /usr/share/doc/${PF}
	doins demo.py
}
