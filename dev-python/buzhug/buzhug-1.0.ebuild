# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/buzhug/buzhug-1.0.ebuild,v 1.1 2008/03/01 11:59:33 dev-zero Exp $

NEED_PYTHON=2.3

inherit distutils

DESCRIPTION="Fast, pure-Python database engine, using a syntax that Python programmers should find very intuitive"
HOMEPAGE="http://buzhug.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND=">=app-arch/unzip-5"
RDEPEND=""

src_install() {
	distutils_src_install
	if use doc; then
		cd "${S}/${PN}/doc"
		dohtml *.html *.css
	fi
}
