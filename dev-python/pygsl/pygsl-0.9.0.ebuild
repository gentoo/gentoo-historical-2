# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pygsl/pygsl-0.9.0.ebuild,v 1.1 2007/10/05 20:12:08 bicatali Exp $

inherit distutils

DESCRIPTION="A Python interface for the GNU scientific library (gsl)."
HOMEPAGE="http://pygsl.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

DEPEND=">=sci-libs/gsl-1.8
	>=dev-python/numpy-1.0"

src_test() {
	cd "${S}/tests"
	PYTHONPATH=$(ls -d ../build/lib*) "${python}" run_test.py || die "tests failed"
}

src_install() {
	distutils_src_install
	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples || die "install examples failed"
	fi
}
