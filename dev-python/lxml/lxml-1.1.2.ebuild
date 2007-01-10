# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/lxml/lxml-1.1.2.ebuild,v 1.1 2007/01/10 10:22:11 dev-zero Exp $

inherit distutils eutils multilib

DESCRIPTION="lxml is a Pythonic binding for the libxml2 and libxslt libraries"
HOMEPAGE="http://codespeak.net/lxml/"
SRC_URI="http://codespeak.net/lxml/${P}.tgz"

LICENSE="BSD GPL-2 as-is"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~x86"
IUSE="doc examples"

# Note: This version comes with it's own bundled svn version of pyrex
DEPEND=">=dev-libs/libxml2-2.6.16
		>=dev-libs/libxslt-1.1.12"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}-distutils.patch"
}

src_install() {
	distutils_src_install

	if use doc ; then
		dohtml doc/html/*

		dodoc *.txt
		docinto doc
		dodoc doc/*.txt
	fi
	if use examples ; then
		insinto /usr/share/doc/${PF}/examples
		doins -r samples/*
	fi
}

src_test() {
	distutils_python_version
	python setup.py build_ext -i || die "building extensions for test use failed"
	einfo "Running test"
	python test.py || die "tests failed"
	export PYTHONPATH="${PYTHONPATH}:${S}/src"
	einfo "Running selftest"
	python selftest.py || die "selftest failed"
	einfo "Running selftest2"
	python selftest2.py || die "selftest2 failed"
}
