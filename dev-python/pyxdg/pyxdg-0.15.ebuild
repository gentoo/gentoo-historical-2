# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pyxdg/pyxdg-0.15.ebuild,v 1.8 2008/01/17 03:09:31 jer Exp $

NEED_PYTHON=2.4

inherit distutils

DESCRIPTION="a python module to deal with freedesktop.org specifications."
SRC_URI="http://www.freedesktop.org/~lanius/${P}.tar.gz"
HOMEPAGE="http://pyxdg.freedesktop.org/"
LICENSE="LGPL-2"
KEYWORDS="amd64 ~hppa ~ia64 ppc ~sparc x86 ~x86-fbsd"
SLOT="0"
IUSE=""

src_install () {
	DOCS="AUTHORS"
	distutils_src_install

	insinto /usr/share/doc/${P}/test
	insopts -m 755
	doins test/*
}
