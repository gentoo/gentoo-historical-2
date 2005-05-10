# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/urwid/urwid-0.8.7.ebuild,v 1.1 2005/05/10 00:29:42 pythonhead Exp $

inherit distutils

DESCRIPTION="Urwid is a curses-based user interface library for Python."
HOMEPAGE="http://excess.org/urwid/"
SRC_URI="http://excess.org/urwid/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~x86 ~ppc"

IUSE="examples"
DEPEND="virtual/python"

src_test() {
	${python} test_urwid.py || die "unit tests failed"
}

src_install() {
	distutils_src_install

	dohtml tutorial.html reference.html
	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins browse.py dialog.py edit.py calc.py fib.py tour.py
	fi
}
