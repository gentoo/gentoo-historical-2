# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/cherrypy/cherrypy-3.1.2.ebuild,v 1.4 2009/11/08 20:38:47 arfrever Exp $

inherit distutils

MY_P=CherryPy-${PV}

DESCRIPTION="CherryPy is a pythonic, object-oriented web development framework."
HOMEPAGE="http://www.cherrypy.org/ http://pypi.python.org/pypi/CherryPy"
SRC_URI="http://download.cherrypy.org/${PN}/${PV}/${MY_P}.tar.gz"

IUSE="doc"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ppc ~x86 ~amd64-linux ~x86-linux ~x86-macos"
LICENSE="BSD"

DEPEND=""
RDEPEND=""

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	sed -i \
		-e 's/"cherrypy.tutorial",//' \
		-e "/('cherrypy\/tutorial',/, /),/d" \
		setup.py || die "sed failed"

}

src_install() {
	distutils_src_install
	if use doc ; then
		insinto "/usr/share/doc/${PF}"
		doins -r cherrypy/tutorial
	fi
}

src_test() {
	PYTHONPATH=. "${python}" cherrypy/test/test.py --dumb || die "test failed"
}
