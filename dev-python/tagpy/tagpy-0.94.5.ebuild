# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/tagpy/tagpy-0.94.5.ebuild,v 1.5 2009/02/24 01:37:10 josejx Exp $

inherit distutils

DESCRIPTION="Python bindings for media-libs/taglib"
HOMEPAGE="http://news.tiker.net/software/tagpy/"
SRC_URI="http://cheeseshop.python.org/packages/source/t/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~ia64 ~ppc ppc64 ~sparc x86"
IUSE=""

RDEPEND="virtual/python
	>=media-libs/taglib-1.4
	>=dev-libs/boost-1.34.1"

DEPEND="${RDEPEND}
	dev-python/setuptools"

src_compile() {
	./configure \
		--taglib-inc-dir="/usr/include/taglib" \
		--boost-python-libname="boost_python-mt"
	distutils_src_compile
}

src_install() {
	distutils_src_install
	insinto /usr/share/doc/${PF}/examples
	doins test/*
}
