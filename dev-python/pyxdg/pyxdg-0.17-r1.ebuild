# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pyxdg/pyxdg-0.17-r1.ebuild,v 1.10 2009/11/05 20:37:10 maekke Exp $

NEED_PYTHON=2.4

inherit distutils

DESCRIPTION="a python module to deal with freedesktop.org specifications."
SRC_URI="http://www.freedesktop.org/~lanius/${P}.tar.gz"
HOMEPAGE="http://pyxdg.freedesktop.org/"
LICENSE="LGPL-2"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd"
SLOT="0"
IUSE=""

src_unpack() {
	distutils_src_unpack
	epatch "${FILESDIR}/${PN}-subprocess.patch"
}

src_install () {
	DOCS="AUTHORS"
	distutils_src_install
	python_need_rebuild

	insinto /usr/share/doc/${P}/test
	insopts -m 755
	doins test/*
}
