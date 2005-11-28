# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/cherrypy/cherrypy-2.1.0.ebuild,v 1.2 2005/11/28 11:25:24 marienz Exp $

inherit distutils eutils

MY_P=${P/cherrypy/CherryPy}

DESCRIPTION="CherryPy is a pythonic, object-oriented web development framework."
SRC_URI="mirror://sourceforge/cherrypy/${MY_P}.tar.gz"
HOMEPAGE="http://www.cherrypy.org/"
DEPEND=">=dev-lang/python-2.3"
IUSE=""
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
LICENSE="BSD"
S=${WORKDIR}/${MY_P}

DOCS="CHANGELOG.txt CHERRYPYTEAM.txt"

src_unpack() {
	unpack ${A} || die
	cd ${S}
	epatch ${FILESDIR}/${P}-test-gentoo.patch
}

src_install() {
	distutils_src_install
	insinto /usr/share/doc/${P}
	doins -r cherrypy/tutorial
	insinto /usr/share/${PN}
	doins -r cherrypy/test
}

src_test() {
	cd cherrypy/test
	python test.py || die "Test failed."
}

