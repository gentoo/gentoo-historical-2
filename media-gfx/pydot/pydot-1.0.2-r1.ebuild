# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/pydot/pydot-1.0.2-r1.ebuild,v 1.4 2010/06/12 17:19:50 arfrever Exp $

EAPI="3"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils eutils

DESCRIPTION="Python interface to Graphviz's Dot language"
HOMEPAGE="http://code.google.com/p/pydot/ http://pypi.python.org/pypi/pydot"
SRC_URI="http://pydot.googlecode.com/files/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

DEPEND="dev-python/setuptools"
RDEPEND="dev-python/pyparsing
	media-gfx/graphviz"

PYTHON_MODNAME="dot_parser.py pydot.py"

src_prepare() {
	distutils_src_prepare
	epatch "${FILESDIR}"/${P}-setup.patch
}
