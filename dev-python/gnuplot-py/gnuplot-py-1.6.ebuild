# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/gnuplot-py/gnuplot-py-1.6.ebuild,v 1.7 2004/02/22 17:19:54 brad_mssw Exp $

inherit distutils

IUSE=""
DESCRIPTION="A python wrapper for Gnuplot"
HOMEPAGE="http://gnuplot-py.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="x86 amd64"
SLOT="0"
DEPEND="virtual/python
	media-gfx/gnuplot
	dev-python/numeric"

src_install() {
	distutils_src_install
	dohtml doc/Gnuplot/*
	insinto /usr/share/doc/${PF}
	doins demo.py
}
