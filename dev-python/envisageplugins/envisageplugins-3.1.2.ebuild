# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/envisageplugins/envisageplugins-3.1.2.ebuild,v 1.2 2010/07/07 03:42:55 arfrever Exp $

EAPI="3"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"
DISTUTILS_SRC_TEST="setup.py"

inherit distutils

MY_PN="EnvisagePlugins"
MY_P="${MY_PN}-${PV}"
DESCRIPTION="Enthought Tool Suite plugins for the Envisage framework"
HOMEPAGE="http://code.enthought.com/projects/envisage_plugins.php http://pypi.python.org/pypi/EnvisagePlugins"
SRC_URI="http://www.enthought.com/repo/ETS/${MY_P}.tar.gz"

IUSE="examples"
#IUSE="examples test"
SLOT="0"
KEYWORDS="~amd64 ~x86"
LICENSE="BSD"

RDEPEND=">=dev-python/envisagecore-3.1.2
	>=dev-python/traitsgui-3.3.0"

DEPEND="dev-python/setuptools"
# tests need an X display
#	test? ( >=dev-python/nose-0.10.3
#			>=dev-python/envisagecore-3.1.2 )"
RESTRICT="test"

S="${WORKDIR}/${MY_P}"
PYTHON_MODNAME="enthought"

src_prepare() {
	sed -i \
		-e "s/self.run_command('build_docs')/pass/" \
		-e "s/setupdocs>=1.0//" \
		setup.py || die
}

src_install() {
	find "${S}" -name \*LICENSE.txt -delete
	distutils_src_install
	insinto /usr/share/doc/${PF}
	if use examples; then
		doins -r examples || die
	fi
}
