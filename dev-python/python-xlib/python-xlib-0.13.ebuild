# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/python-xlib/python-xlib-0.13.ebuild,v 1.2 2007/04/21 20:12:02 pythonhead Exp $

inherit distutils

DESCRIPTION="A fully functional X client library for Python, written in Python"
HOMEPAGE="http://python-xlib.sourceforge.net/"
SRC_URI="mirror://sourceforge/python-xlib/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc ~alpha ~ia64 ~amd64"
IUSE="doc"
DEPEND="${RDEPEND}
	doc? ( >=app-text/tetex-2.0.2-r9
		>=sys-apps/texinfo-4.8-r2 )"

src_compile() {
	distutils_src_compile
	if use doc; then
		cd doc
		emake || die "make docs failed"
	fi
}

src_install () {
	distutils_src_install
	if use doc; then
		dohtml -r doc/html/
	    dodoc doc/ps/python-xlib.ps
	fi
}

src_test() {
	for pytest in $(ls test/*py); do
		PYTHONPATH=. ${python} ${pytest} || die "test failed"
	done
}

