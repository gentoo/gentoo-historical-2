# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pyxdg/pyxdg-0.15.ebuild,v 1.3 2006/11/20 18:05:04 opfer Exp $

inherit distutils

DESCRIPTION="a python module to deal with freedesktop.org specifications."
SRC_URI="http://www.freedesktop.org/~lanius/${P}.tar.gz"
HOMEPAGE="http://pyxdg.freedesktop.org/"
LICENSE="LGPL-2"

KEYWORDS="~amd64 ~ia64 ~ppc x86"
DEPEND=">=dev-lang/python-2.4"
SLOT="0"
IUSE=""

src_install () {
	distutils_src_install
	dodoc AUTHORS
	insinto /usr/share/doc/${P}/test
	insopts -m 755
	doins test/test-{menu,desktop,desktop-write,icon}.py
}
