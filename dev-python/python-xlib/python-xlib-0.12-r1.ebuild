# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/python-xlib/python-xlib-0.12-r1.ebuild,v 1.1 2004/03/02 15:11:42 kloeri Exp $

inherit distutils

S=${WORKDIR}/${P}
DESCRIPTION="A fully functional X client library for Python, written in Python."
SRC_URI="mirror://sourceforge/python-xlib/${P}.tar.gz"
HOMEPAGE="http://python-xlib.sourceforge.net/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ~ppc ~sparc alpha ia64"
IUSE=""

src_install () {
	epatch "${FILESDIR}/${P}-info.patch"
	mydoc="doc/ps/python-xlib.ps PKG-INFO TODO"
	distutils_src_install
	dohtml -r doc/html/
	doinfo doc/info/*.info*
}
