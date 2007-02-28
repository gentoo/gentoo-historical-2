# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pypcap/pypcap-1.1.ebuild,v 1.1 2007/02/28 00:40:50 dev-zero Exp $

NEED_PYTHON=2.3

inherit distutils

DESCRIPTION="Simplified object-oriented Python extension module for libpcap"
HOMEPAGE="http://code.google.com/p/pypcap/"
SRC_URI="http://${PN}.googlecode.com/files/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86"
IUSE="examples"

DEPEND="virtual/libpcap"
RDEPEND="${DEPEND}"

src_compile() {
	"${python}" setup.py config || die "config failed"
	distutils_src_compile
}

src_install() {
	DOCS="CHANGES"
	distutils_src_install
	if use examples ; then
		insinto /usr/share/doc/${PF}
		doins testsniff.py
	fi
}

src_test() {
	# PYTHONPATH is set correctly in the test itself
	"${python}" test.py || die "tests failed"
}
