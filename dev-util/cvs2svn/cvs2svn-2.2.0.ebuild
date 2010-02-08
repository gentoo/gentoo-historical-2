# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/cvs2svn/cvs2svn-2.2.0.ebuild,v 1.4 2010/02/08 08:57:44 pva Exp $

EAPI="2"
PYTHON_USE_WITH_OR="berkdb gdbm"
PYTHON_USE_WITH_OPT="test"

inherit eutils distutils

FILEVER="44372"

DESCRIPTION="Convert a CVS repository to a Subversion repository"
HOMEPAGE="http://cvs2svn.tigris.org/"
SRC_URI="http://cvs2svn.tigris.org/files/documents/1462/${FILEVER}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="test"

DEPEND="dev-lang/python
	>=dev-util/subversion-1.0.9"
RDEPEND="${DEPEND}
	app-text/rcs"

src_prepare() {
	epatch "${FILESDIR}/2.2.0-deprecated-modules.patch"
	distutils_src_prepare
}

src_install() {
	distutils_src_install
	insinto "/usr/share/${PN}"
	doins -r contrib cvs2svn-example.options
	doman cvs2svn.1
}

src_test() {
	# Need this because subversion is localized, but the tests aren't
	export LC_ALL=C
	python -W ignore run-tests.py || die "tests failed"
}

pkg_postinst() {
	elog "Additional scripts and examples have been installed to:"
	elog "  /usr/share/${PN}/"
}
