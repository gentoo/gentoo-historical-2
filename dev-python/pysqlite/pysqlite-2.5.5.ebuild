# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pysqlite/pysqlite-2.5.5.ebuild,v 1.1 2009/03/31 20:54:24 patrick Exp $

NEED_PYTHON=2.3

inherit distutils

DESCRIPTION="Python wrapper for the local database Sqlite"
#SRC_URI="http://initd.org/pub/software/pysqlite/releases/${PV:0:3}/${PV}/pysqlite-${PV}.tar.gz"
SRC_URI="http://oss.itsystementwicklung.de/download/pysqlite/${PV:0:3}/${PV}/pysqlite-${PV}.tar.gz"
HOMEPAGE="http://pysqlite.org/"

KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
LICENSE="pysqlite"
SLOT="2"
IUSE="examples"

DEPEND=">=dev-db/sqlite-3.1"
RDEPEND=${DEPEND}

PYTHON_MODNAME="pysqlite2"

src_unpack() {
	distutils_src_unpack
	# don't install pysqlite2.test
	sed -i -e 's/, "pysqlite2.test"//' \
		setup.py || die "sed in setup.py failed"
	# workaround to make checks work without installing them
	sed -i -e "s/pysqlite2.test/test/" \
		pysqlite2/test/__init__.py || die "sed failed"
	# correct encoding
	sed -i -e "s/\(coding: \)ISO-8859-1/\1utf-8/" \
		pysqlite2/__init__.py pysqlite2/dbapi2.py || die "sed failed"
}

src_install() {
	distutils_src_install

	rm -rf "${D}"/usr/pysqlite2-doc

	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r doc/code
	fi
}

src_test() {
	cd pysqlite2
	# tests use this as a nonexistant file
	addpredict /foo/bar
	PYTHONPATH="$(ls -d ../build/lib.*)" "${python}" -c \
		"from test import test;import sys;sys.exit(test())" \
		|| die "test failed"
}
