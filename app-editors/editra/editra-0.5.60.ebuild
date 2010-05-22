# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/editra/editra-0.5.60.ebuild,v 1.1 2010/05/22 20:34:47 dirtyepic Exp $

EAPI=2
SUPPORT_PYTHON_ABIS=1
PYTHON_DEPEND="2:2.5"

inherit distutils eutils fdo-mime python

MY_PN=${PN/e/E}

DESCRIPTION="Multi-platform text editor supporting over 50 programming languages."
HOMEPAGE="http://editra.org http://pypi.python.org/pypi/Editra"
SRC_URI="http://editra.org/uploads/src/${MY_PN}-${PV}.tar.gz"

LICENSE="wxWinLL-3.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="spell"

DEPEND=">=dev-python/wxpython-2.8.9.2:2.8
		>=dev-python/setuptools-0.6"
# setuptools is RDEPEND because it's used by the runtime for installing plugins
RDEPEND="${DEPEND}
	spell? ( dev-python/pyenchant )"

RESTRICT_PYTHON_ABIS="3.*"

S="${WORKDIR}"/${MY_PN}-${PV}

src_compile() {
	distutils_src_compile --no-clean # http://code.google.com/p/editra/issues/detail?id=481
}

src_install() {
	distutils_src_install --no-clean
	insinto /usr/share/pixmaps
	doins "${S}"/pixmaps/editra.png
	make_desktop_entry Editra Editra editra "Development;TextEditor"
	dodoc FAQ THANKS
}

pkg_postinst() {
	distutils_pkg_postinst
	fdo-mime_desktop_database_update
}

pkg_postrm() {
	distutils_pkg_postrm
	fdo-mime_desktop_database_update
}
