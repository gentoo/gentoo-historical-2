# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/psycopg/psycopg-1.1.5.1.ebuild,v 1.7 2004/06/25 01:36:56 agriffis Exp $

inherit distutils

DESCRIPTION="PostgreSQL database adapter for the Python" # best one
SRC_URI="http://initd.org/pub/software/psycopg/PSYCOPG-1-1/${P}.tar.gz"
HOMEPAGE="http://www.initd.org/software/psycopg.py"

DEPEND="virtual/python
	>=dev-python/egenix-mx-base-2.0.3
	>=dev-db/postgresql-7.1.3"

SLOT="0"
KEYWORDS="x86 sparc ~alpha"
LICENSE="GPL-2"
IUSE=""

src_compile() {
	distutils_python_version
	econf \
		--with-mxdatetime-includes=/usr/lib/python${PYVER}/site-packages/mx/DateTime/mxDateTime \
		--with-postgres-includes=/usr/include/postgresql/server \
		|| die "./configure failed"
	emake || die
}

src_install () {
	cd ${S}
	sed -e 's:\(echo "  install -m 555 $$mod \)\($(PY_MOD_DIR)\)\("; \\\):\1${D}\2/$$mod\3:' \
		-e 's:\($(INSTALL)  -m 555 $$mod \)\($(PY_MOD_DIR)\)\(; \\\):\1${D}\2/$$mod\3:' \
		-i Makefile
	make install || die

	dodoc AUTHORS ChangeLog COPYING CREDITS INSTALL README NEWS RELEASE-1.0 SUCCESS TODO
	docinto doc
	dodoc   doc/*
	docinto doc/examples
	dodoc   doc/examples/*
}
