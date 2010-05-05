# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-util/mattricks/mattricks-0.7.ebuild,v 1.6 2010/05/05 05:27:23 tupone Exp $
EAPI="2"
PYTHON_DEPEND="2"
inherit eutils python distutils

MY_P=${P/m/M}
DESCRIPTION="Hattrick Manager"
HOMEPAGE="http://www.lysator.liu.se/mattricks/download.en.html"
SRC_URI="http://www.lysator.liu.se/mattricks/files/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="ppc x86"
IUSE=""

DEPEND="<dev-python/wxpython-2.8
		dev-python/pyxml"

S=${WORKDIR}/${MY_P}

pkg_setup() {
	python_set_active_version 2
}

src_prepare() {
	distutils_src_prepare
	epatch "${FILESDIR}"/${P}-wxversion.patch
	python_convert_shebangs -r 2 .
}
