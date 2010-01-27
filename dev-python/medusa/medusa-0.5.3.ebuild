# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/medusa/medusa-0.5.3.ebuild,v 1.12 2010/01/27 19:01:34 armin76 Exp $

inherit distutils

IUSE=""
DESCRIPTION="A framework for writing long-running, high-performance network servers in Python, using asynchronous sockets"
HOMEPAGE="http://oedipus.sourceforge.net/medusa/"
## NOTE: for some reason i get 403 to this URL. must mirror on gentoo
#SRC_URI="http://www.amk.ca/files/python/${P}.tar.gz"
SRC_URI="mirror://gentoo/${P}.tar.gz"
LICENSE="PYTHON"
SLOT="0"
KEYWORDS="~alpha ~arm x86"
DEPEND="virtual/python"

src_install () {
	DOCS="CHANGES.txt docs/*.txt"
	distutils_src_install

	dodir /usr/share/doc/${PF}/example
	cp -r demo/* ${D}/usr/share/doc/${PF}/example
	dohtml docs/*.html docs/*.gif
}
