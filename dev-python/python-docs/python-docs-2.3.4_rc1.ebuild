# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/python-docs/python-docs-2.3.4_rc1.ebuild,v 1.1 2004/05/14 14:56:56 kloeri Exp $

MY_PV=${PV/_rc/c}

DESCRIPTION="HTML documentation for Python"
HOMEPAGE="http://www.python.org/doc/2.3/"
SRC_URI="http://www.python.org/ftp/python/doc/${MY_PV}/html-${MY_PV}.tar.bz2"

LICENSE="PSF-2.2"
SLOT="2.3"
KEYWORDS="~x86 ~alpha"
IUSE=""

DEPEND=""
RDEPEND=""

S=${WORKDIR}

src_install() {
	docinto html
	cp -R ${S}/Python-Docs-${MY_PV}/* ${D}/usr/share/doc/${PF}/html
	dodir /etc/env.d
	echo "PYTHONDOCS=/usr/share/doc/${PF}/html" > ${D}/etc/env.d/50python-docs
}
