# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pysqlite/pysqlite-2.3.1.ebuild,v 1.6 2006/08/08 15:59:16 wolf31o2 Exp $

inherit distutils

DESCRIPTION="Python wrapper for the local database Sqlite"
SRC_URI="http://initd.org/pub/software/pysqlite/releases/${PV:0:3}/${PV}/pysqlite-${PV}.tar.gz"
HOMEPAGE="http://initd.org/tracker/pysqlite/"

KEYWORDS="~alpha amd64 ia64 ppc ~ppc64 ~sparc x86 ~x86-fbsd"
LICENSE="pysqlite"
SLOT="2"
IUSE=""

DEPEND=">=dev-lang/python-2.3
	>=dev-db/sqlite-3.1"

src_install() {
	distutils_src_install

	mv "${D}"/usr/pysqlite2-doc/* "${D}"/usr/share/doc/${PF}
	rm -rf "${D}"/usr/pysqlite2-doc
}

src_test() {
	cd build/lib*
	# tests use this as a nonexistant file
	addpredict /foo/bar
	PYTHONPATH=. "${python}" -c \
		"from pysqlite2.test import test;import sys;sys.exit(test())" \
		|| die "test failed"
}
