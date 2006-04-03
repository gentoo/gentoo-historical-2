# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/lxml/lxml-0.9.1.ebuild,v 1.1 2006/04/03 18:34:01 lucass Exp $

inherit distutils eutils

DESCRIPTION="lxml is a Pythonic binding for the libxml2 and libxslt libraries"
HOMEPAGE="http://codespeak.net/lxml/"
SRC_URI="http://codespeak.net/lxml/${P}.tgz"

LICENSE="BSD GPL-2 as-is"
SLOT="0"
KEYWORDS="~ia64 ~x86"
IUSE=""

DEPEND=">=dev-libs/libxml2-2.6.16
		>=dev-libs/libxslt-1.1.12
		>=dev-python/pyrex-0.9.3
		virtual/python"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${P}-distutils.diff
}

src_test() {
	make test
}

src_install() {
	distutils_src_install

	dodoc *.txt
	docinto doc
	dodoc doc/*.txt
	docinto doc/licenses
	dodoc doc/licenses/*

	insinto /usr/share/doc/${PF}
	doins -r samples
}

