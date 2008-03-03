# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/tagpy/tagpy-0.93.ebuild,v 1.5 2008/03/03 23:24:59 angelos Exp $

inherit distutils

DESCRIPTION="Python bindings for media-libs/taglib"
HOMEPAGE="http://news.tiker.net/software/tagpy"
SRC_URI="http://news.tiker.net/news.tiker.net/download/software/tagpy/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~ia64 ppc64 x86"
IUSE=""

DEPEND="virtual/python
	>=media-libs/taglib-1.4
	>=dev-libs/boost-1.34.1"

src_compile() {
	./configure \
		--taglib-inc-dir="/usr/include/taglib" \
		--boost-python-lib-names="boost_python-mt"
	distutils_src_compile
}

src_install() {
	distutils_src_install
	insinto /usr/share/doc/${PF}/examples
	doins test/*
}
