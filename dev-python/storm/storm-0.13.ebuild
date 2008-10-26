# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/storm/storm-0.13.ebuild,v 1.1 2008/10/26 05:04:25 neurogeek Exp $

NEED_PYTHON=2.4

inherit distutils

DESCRIPTION="An object-relational mapper for Python developed at Canonical."
HOMEPAGE="https://storm.canonical.com/FrontPage"
SRC_URI="https://launchpad.net/${PN}/trunk/${PV}/+download/${P}.tar.bz2"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="mysql postgres sqlite test"

RDEPEND="mysql? ( dev-python/mysql-python )
	postgres? ( =dev-python/psycopg-2* )
	sqlite? ( || ( dev-python/pysqlite >=dev-lang/python-2.5 ) )"
DEPEND="dev-python/setuptools
	test? ( || ( dev-python/pysqlite >=dev-lang/python-2.5 ) )"

DOCS="tests/tutorial.txt"

src_test() {
	if use postgres ; then
		elog "To run the PostgreSQL-tests, you need:"
		elog "  - a running postgresql-server"
		elog "  - an already existing database 'db'"
		elog "  - a user 'user' with full permissions on that database"
		elog "  - and an environment variable STORM_POSTGRES_URI=\"postgres://user:password@host:1234/db\""
	fi
	if use mysql ; then
		elog "To run the MySQL-tests, you need:"
		elog "  - a running mysql-server"
		elog "  - an already existing database 'db'"
		elog "  - a user 'user' with full permissions on that database"
		elog "  - and an environment variable STORM_MYSQL_URI=\"mysql://user:password@host:1234/db\""
	fi

	PYTHONPATH=. "${python}" test || die "tests failed"
}
