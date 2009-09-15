# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pygments/pygments-1.1.1.ebuild,v 1.1 2009/09/15 20:21:58 arfrever Exp $

EAPI="2"
SUPPORT_PYTHON_ABIS="1"

inherit distutils

MY_PN="Pygments"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Pygments is a syntax highlighting package written in Python."
HOMEPAGE="http://pygments.org/"
SRC_URI="http://pypi.python.org/packages/source/P/${MY_PN}/${MY_P}.tar.gz"

LICENSE="BSD"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"
SLOT="0"
IUSE="doc test"

DEPEND="test? ( media-fonts/ttf-bitstream-vera
		dev-python/nose	)"
RDEPEND=""

S="${WORKDIR}/${MY_P}"
DOCS="CHANGES"

src_prepare() {
	distutils_src_prepare

	# Make lexer recognize ebuilds as bash input
	sed -i \
			-e "/\(BashLexer\|aliases\)/s/\('sh'\)/\1, 'ebuild', 'eclass'/" \
			-e "/\(BashLexer\|filenames\)/s/\('\*\.sh'\)/\1, '*.ebuild', '*.eclass'/" \
				${PN}/lexers/_mapping.py ${PN}/lexers/other.py ||\
		die "sed failed."

	# Our usual PYTHONPATH manipulation trick doesn't work, it will try to run
	# tests on the installed version:
	if use test; then
		sed -e "s/import pygments/sys.path.insert(0, '.');import pygments/" -i tests/run.py || die "sed failed"
	fi
}

src_test() {
	testing() {
		"$(PYTHON)" tests/run.py
	}
	python_execute_function --nonfatal testing
}

src_install(){
	distutils_src_install
	use doc && dohtml -r docs/build/
}
