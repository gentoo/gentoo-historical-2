# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/medusa/medusa-0.5.3.ebuild,v 1.9 2004/06/25 01:33:50 agriffis Exp $

inherit distutils

IUSE=""
DESCRIPTION="Medusa is a framework for writing long-running, high-performance network servers in Python, using asynchronous sockets"
HOMEPAGE="http://oedipus.sourceforge.net/medusa/"
## NOTE: for some reason i get 403 to this URL. must mirror on gentoo
#SRC_URI="http://www.amk.ca/files/python/${P}.tar.gz"
SRC_URI="mirror://gentoo/${P}.tar.gz"
LICENSE="PYTHON"
SLOT="0"
KEYWORDS="x86"
DEPEND="virtual/python"

src_install () {
	mydoc="CHANGES.txt LICENSE.txt README.txt docs/*.txt"
	distutils_src_install

	dodir /usr/share/doc/${PF}/example
	cp -r demo/* ${D}/usr/share/doc/${PF}/example
	dohtml docs/*.html docs/*.gif
}
