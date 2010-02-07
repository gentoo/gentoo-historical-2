# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/utidylib/utidylib-0.2-r1.ebuild,v 1.2 2010/02/07 20:40:17 pva Exp $

EAPI="2"
inherit eutils distutils

MY_P="uTidylib-${PV}"

DESCRIPTION="TidyLib Python wrapper"
HOMEPAGE="http://utidylib.berlios.de/"
SRC_URI="mirror://berlios/${PN}/${MY_P}.zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE="doc test"

RDEPEND=">=dev-lang/python-2.3
	app-text/htmltidy
	dev-python/ctypes"
DEPEND="${RDEPEND}
	app-arch/unzip
	doc? ( dev-python/epydoc )
	test? ( dev-python/twisted )"

PYTHON_MODNAME="tidy"
S="${WORKDIR}/${MY_P}"

src_prepare(){
	epatch "${FILESDIR}/${P}-no-docs-in-site-packages.patch"
	epatch "${FILESDIR}/${P}-fix_tests.patch"
}

src_compile() {
	distutils_src_compile
	if use doc; then
		python gendoc.py || die "building api docs failed"
	fi
}

src_test() {
	einfo "${S}"
	einfo "$(ls ${S}/foo.htm)"
	PYTHONPATH="." trial tidy || die "tests failed"
}

src_install() {
	distutils_src_install
	use doc && dohtml -r apidoc
}
