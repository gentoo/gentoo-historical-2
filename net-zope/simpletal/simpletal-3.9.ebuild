# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-zope/simpletal/simpletal-3.9.ebuild,v 1.2 2004/06/25 01:25:01 agriffis Exp $

IUSE=""

MY_P=SimpleTAL

inherit distutils

DESCRIPTION="SimpleTAL is a stand alone Python implementation of the TAL, TALES and METAL specifications used in Zope to power HTML and XML templates."
SRC_URI="http://www.owlfish.com/software/simpleTAL/downloads/${MY_P}-${PV}.tar.gz"
HOMEPAGE="http://www.owlfish.com/software/simpleTAL/"
DEPEND="virtual/python"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc ~alpha"

S=${WORKDIR}/${MY_P}-${PV}

src_compile() {
	distutils_src_compile || die
}

src_install() {
	distutils_src_install

	docinto examples/basic
	dodoc examples/basic/basic-example.py
	dodoc examples/basic/basic.html

	docinto examples/cgi-example
	dodoc examples/cgi-example/simple-cgi.py
	dodoc examples/cgi-example/fields.html
	dodoc examples/cgi-example/results.html

	docinto examples/metal-example
	dodoc examples/metal-example/metal-example.py
	dodoc examples/metal-example/macro.html
	dodoc examples/metal-example/page.html

	docinto examples/structure-example
	dodoc examples/structure-example/structure-example.py
	dodoc examples/structure-example/structure.html
}
