# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pypgsql/pypgsql-2.3.ebuild,v 1.8 2004/06/25 01:42:28 agriffis Exp $

DESCRIPTION="Python Interface to PostgreSQL"
HOMEPAGE="http://pypgsql.sourceforge.net/"
SRC_URI="mirror://sourceforge/pypgsql/pyPgSQL-${PV}.tar.gz"
LICENSE="GPL-2"
KEYWORDS="x86"
DEPEND="virtual/glibc dev-db/postgresql virtual/python"
S=${WORKDIR}/${PN}
IUSE=""

SLOT="0"

src_compile() {
	cd ${S}
	python setup.py build || die
}

src_install () {
	python setup.py install --prefix=${D}/usr || die
	dodir /usr/share/doc/${PF}/
	cp -R examples ${D}/usr/share/doc/${PF}
	dodoc README
}
