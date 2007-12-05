# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/opendbx/opendbx-1.2.3-r1.ebuild,v 1.3 2007/12/05 22:08:49 swegener Exp $

inherit flag-o-matic

DESCRIPTION="OpenDBX - A database abstraction layer"
HOMEPAGE="http://www.linuxnetworks.de/doc/index.php/OpenDBX"
SRC_URI="http://www.linuxnetworks.de/opendbx/download/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="bindist firebird mysql oracle postgres sqlite sqlite3"

DEPEND="mysql? ( virtual/mysql )
	postgres? ( dev-db/postgresql )
	sqlite? ( <dev-db/sqlite-3 )
	sqlite3? ( =dev-db/sqlite-3* )
	oracle? ( dev-db/oracle-instantclient-basic )
	!bindist? ( firebird? ( dev-db/firebird ) )"
RDEPEND="${DEPEND}"

pkg_setup() {
	if ! ( use !bindist && use firebird || use mysql || use oracle || use postgres || use sqlite || use sqlite3 )
	then
		die "Need at least one of firebird, mysql, oracle, postgres, sqlite and sqlite3 activated!"
	fi

	if use oracle && [[ ! -d ${ORACLE_HOME} ]]
	then
		die "Oracle support requested, but ORACLE_HOME not set to a valid directory!"
	fi

	use mysql && append-cppflags -I/usr/include/mysql
	use firebird && append-cppflags -I/opt/firebird/include
	use oracle && append-ldflags -L${ORACLE_HOME}/lib
}

src_compile() {
	local backends=""

	use !bindist && use firebird && backends="${backends} firebird"
	use mysql && backends="${backends} mysql"
	use oracle && backends="${backends} oracle"
	use postgres && backends="${backends} pgsql"
	use sqlite && backends="${backends} sqlite"
	use sqlite3 && backends="${backends} sqlite3"

	econf --with-backends="${backends}" || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	make install DESTDIR="${D}" || die "make install failed"
	dodoc AUTHORS ChangeLog README
}
