# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/logging/logging-0.4.7.ebuild,v 1.6 2005/04/24 09:25:13 blubb Exp $

inherit distutils

DESCRIPTION="Logging module for Python"
HOMEPAGE="http://www.red-dove.com/python_logging.html"
SRC_URI="http://www.red-dove.com/logging-${PV}.tar.gz"
LICENSE="logging"
SLOT="0"
KEYWORDS="x86 amd64 ~ppc"
IUSE=""
DEPEND="virtual/python"
DOCS="liblogging.tex"

src_install() {
	distutils_src_install
	dohtml python_logging.html default.css
	dodir /usr/share/doc/${PF}/test
	cp -R test/* ${D}/usr/share/doc/${PF}/test/
}

