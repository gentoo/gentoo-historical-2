# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pycurl/pycurl-7.19.0.ebuild,v 1.2 2009/07/10 02:15:25 jer Exp $

inherit distutils

DESCRIPTION="python binding for curl/libcurl"
HOMEPAGE="http://pycurl.sourceforge.net/"
SRC_URI="http://pycurl.sourceforge.net/download/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="examples"

DEPEND=">=net-misc/curl-7.18.1"

PYTHON_MODNAME="curl"

src_install() {
	sed -i \
		-e "/data_files=/d" \
		setup.py || die "sed in setup.py failed."

	distutils_src_install

	dohtml -r doc/*

	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples
		doins -r tests
	fi
}

src_test() {
	emake test || die "test failed"
}
