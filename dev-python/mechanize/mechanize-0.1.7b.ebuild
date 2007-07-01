# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/mechanize/mechanize-0.1.7b.ebuild,v 1.5 2007/07/01 13:20:05 pylon Exp $

NEED_PYTHON=2.3

inherit distutils

DESCRIPTION="Stateful programmatic web browsing in Python"
HOMEPAGE="http://wwwsearch.sourceforge.net/mechanize/"
SRC_URI="http://wwwsearch.sourceforge.net/${PN}/src/${P}.tar.gz"

LICENSE="|| ( BSD ZPL )"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~x86"
IUSE=""

DEPEND=">=dev-python/clientform-0.2.7"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# use distutils instead of setuptools
	sed -i \
		-e 's/not hasattr(sys, "version_info")/1/' \
		setup.py || die "sed in setup.py failed"

	# We don't run coverage tests or functional_tests
	# which access the network, just doctests and unit tests
	sed -i \
		-e '/import coverage/d' \
		test.py || die "sed in test.py failed"
}

src_install() {
	DOCS="0.1-changes.txt"
	# remove to prevent distutils_src_install from installing it
	dohtml *.html
	rm README.html*

	distutils_src_install
}

src_test() {
	PYTHONPATH=build/lib/ "${python}" test.py || die "tests failed"
}
