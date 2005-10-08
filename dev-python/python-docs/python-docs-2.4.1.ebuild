# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/python-docs/python-docs-2.4.1.ebuild,v 1.5 2005/10/08 18:40:08 kloeri Exp $

DESCRIPTION="HTML documentation for Python"
HOMEPAGE="http://www.python.org/doc/${PV}/"
SRC_URI="http://www.python.org/ftp/python/doc/${PV}/html-${PV}.tar.bz2
http://www.python.org/ftp/python/doc/${PV}/info-${PV}.tar.bz2"

LICENSE="PSF-2.2"
SLOT="2.4"
KEYWORDS="alpha ~amd64 ~arm ~hppa ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc x86"
IUSE=""

DEPEND=""
RDEPEND=""

S=${WORKDIR}

src_unpack() {
	unpack html-${PV}.tar.bz2
	mkdir ${S}/info
	cd ${S}/info
	unpack info-${PV}.tar.bz2
	rm -f README python.dir
}

src_install() {
	docinto html
	cp -R ${S}/Python-Docs-${PV}/* ${D}/usr/share/doc/${PF}/html

	insinto /usr/share/info
	doins ${S}/info/*

	dodir /etc/env.d
	echo "PYTHONDOCS=/usr/share/doc/${PF}/html" > ${D}/etc/env.d/50python-docs
}
