# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/m2crypto/m2crypto-0.20.1.ebuild,v 1.5 2009/11/11 00:11:17 ranger Exp $

EAPI="2"
SUPPORT_PYTHON_ABIS="1"

inherit distutils eutils multilib portability

MY_PN="M2Crypto"

DESCRIPTION="A python wrapper for the OpenSSL crypto library"
HOMEPAGE="http://chandlerproject.org/bin/view/Projects/MeTooCrypto"
SRC_URI="http://pypi.python.org/packages/source/${MY_PN:0:1}/${MY_PN}/${MY_PN}-${PV}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ppc ppc64 ~s390 ~sh ~sparc x86 ~x86-fbsd"
IUSE="doc"

RDEPEND=">=dev-libs/openssl-0.9.8"
DEPEND="${RDEPEND}
	>=dev-lang/swig-1.3.25
	doc? ( dev-python/epydoc )
	dev-python/setuptools"
RESTRICT_PYTHON_ABIS="3.*"

PYTHON_MODNAME="${MY_PN}"

S="${WORKDIR}/${MY_PN}-${PV}"

DOCS="CHANGES"

src_test() {
	testing() {
		PYTHONPATH="$(ls -d build-${PYTHON_ABI}/lib*)" "$(PYTHON)" setup.py build -b "build-${PYTHON_ABI}" test
	}
	python_execute_function testing
}

src_install() {
	distutils_src_install

	if use doc; then
		cd "${S}/demo"
		treecopy . "${D}/usr/share/doc/${PF}/example"

		einfo "Generating API documentation..."
		cd "${S}/doc"
		PYTHONPATH="${PYTHONPATH}:${D}$(python_get_sitedir)" epydoc --html --output=api --name=M2Crypto M2Crypto
	fi
	dohtml -r *
}
