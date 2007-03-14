# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pyxdg/pyxdg-0.8.ebuild,v 1.8 2007/03/14 00:31:55 mr_bones_ Exp $

inherit distutils

DESCRIPTION="a python module to deal with freedesktop.org specifications."
SRC_URI="http://www.freedesktop.org/~lanius/${P}.tar.gz"
HOMEPAGE="http://pyxdg.freedesktop.org/"
LICENSE="LGPL-2"

DEPEND="virtual/python"
SLOT="0"
KEYWORDS="x86 ppc amd64"
IUSE=""

src_install () {
	distutils_src_install
	dodoc AUTHORS
	insinto /usr/share/doc/${P}/test
	insopts -m 755
	doins test/test-{menu,desktop,desktop-write,icon}.py
}
