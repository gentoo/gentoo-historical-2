# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/ipython/ipython-0.5.0.ebuild,v 1.3 2004/04/15 23:29:23 randy Exp $

inherit distutils

MY_P=${P/ipython/IPython}

IUSE=""
DESCRIPTION="An advanced interactive shell for Python."
HOMEPAGE="http://ipython.scipy.org/"
SRC_URI="http://ipython.scipy.org/dist/${MY_P}.tar.gz"

LICENSE="PYTHON"
SLOT="0"
KEYWORDS="x86 s390"
DEPEND="virtual/python"
S="${WORKDIR}/${MY_P}"

mydoc="README"

src_install() {
	distutils_src_install
	mv ${D}/usr/share/doc/IPython/* ${D}/usr/share/doc/${PF}/
}
