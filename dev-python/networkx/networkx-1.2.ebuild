# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/networkx/networkx-1.2.ebuild,v 1.1 2010/08/24 20:54:58 bicatali Exp $

EAPI=2
SUPPORT_PYTHON_ABIS="1"
inherit distutils

DESCRIPTION="Python tools to manipulate graphs and complex networks"
HOMEPAGE="http://networkx.lanl.gov"
SRC_URI="http://networkx.lanl.gov/download/networkx/${P}.tar.gz"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
LICENSE="LGPL-2.1"
IUSE="examples"

DEPEND="dev-python/setuptools"
RDEPEND="examples? (
	dev-python/pygraphviz
	dev-python/matplotlib
	dev-python/pyyaml
	dev-python/pyparsing
	sci-libs/scipy )"
RESTRICT_PYTHON_ABIS="3.*"

src_install() {
	distutils_src_install
	rm "${D}"usr/share/doc/${PF}/{LICENSE,INSTALL}.txt || die
	use examples || rm -r "${D}"usr/share/doc/${PF}/examples
}
