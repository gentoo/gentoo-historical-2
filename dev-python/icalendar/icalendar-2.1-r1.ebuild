# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/icalendar/icalendar-2.1-r1.ebuild,v 1.2 2010/02/03 22:05:00 maekke Exp $

EAPI="2"
SUPPORT_PYTHON_ABIS="1"

inherit distutils

DESCRIPTION="Package used for parsing and generating iCalendar files (RFC 2445)."
HOMEPAGE="http://codespeak.net/icalendar/ http://pypi.python.org/pypi/icalendar"
SRC_URI="http://pypi.python.org/packages/source/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=""
DEPEND="dev-python/setuptools"
RESTRICT_PYTHON_ABIS="3.*"

DOCS="CHANGES.txt CREDITS.txt doc/* HISTORY.txt README.txt TODO.txt"

src_prepare() {
	epatch "${FILESDIR}/${PN}-2.0.1-UIDGenerator-fix.patch"
	epatch "${FILESDIR}/${P}-vDatetime-tzinfo-fix.patch"
}

src_test() {
	testing() {
		"$(PYTHON)" test.py
	}
	python_execute_function testing
}
