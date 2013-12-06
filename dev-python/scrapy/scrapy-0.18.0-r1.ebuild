# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/scrapy/scrapy-0.18.0-r1.ebuild,v 1.1 2013/12/06 05:44:16 patrick Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="sqlite(+)"

inherit vcs-snapshot distutils-r1

DESCRIPTION="A high-level Python Screen Scraping framework"
HOMEPAGE="http://scrapy.org http://pypi.python.org/pypi/Scrapy/"
SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="boto doc examples ibl test ssl"
PYTHON_MODNAME="scrapy scrapyd"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? (
		dev-python/boto[${PYTHON_USEDEP}]
		dev-python/queuelib[${PYTHON_USEDEP}]
		dev-python/django[${PYTHON_USEDEP}]
		net-ftp/vsftpd
	)"
RDEPEND="
	dev-python/six[${PYTHON_USEDEP}]
	dev-libs/libxml2[python,${PYTHON_USEDEP}]
	boto? ( dev-python/boto[${PYTHON_USEDEP}] )
	virtual/python-imaging[${PYTHON_USEDEP}]
	dev-python/lxml[${PYTHON_USEDEP}]
	ibl? ( dev-python/numpy[${PYTHON_USEDEP}] )
	ssl? ( dev-python/pyopenssl[${PYTHON_USEDEP}] )
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/twisted-core
	dev-python/twisted-conch
	dev-python/twisted-mail
	dev-python/twisted-web
	>=dev-python/w3lib-1.1[${PYTHON_USEDEP}]
	"

src_compile() {
	distutils-r1_src_compile

	if use doc; then
		emake -C docs html || die "emake html failed"
	fi
}

python_test() {
	PYTHONPATH="${PWD}" bin/runtests.sh || die
}

src_install() {
	distutils-r1_src_install
	if use doc; then
		dohtml -r "${S}"/docs/build/html/
	fi
	if use examples; then
		insinto /usr/share/doc/"${PF}"/examples
		doins -r "${S}"/examples/*
	fi
}
