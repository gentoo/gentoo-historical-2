# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/python-docs/python-docs-2.4.ebuild,v 1.1 2005/01/05 00:33:28 pythonhead Exp $

DESCRIPTION="HTML documentation for Python"
HOMEPAGE="http://www.python.org/doc/2.4/"
SRC_URI="http://www.python.org/ftp/python/doc/${PV}/html-${PV}.tar.bz2"

LICENSE="PSF-2.2"
SLOT="2.4"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~s390 ~sh ~sparc ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

S=${WORKDIR}

src_install() {
	docinto html
	cp -R ${S}/Python-Docs-${PV}/* ${D}/usr/share/doc/${PF}/html
	dodir /etc/env.d
	echo "PYTHONDOCS=/usr/share/doc/${PF}/html" > ${D}/etc/env.d/50python-docs
}
