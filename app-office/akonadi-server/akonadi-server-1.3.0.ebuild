# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-office/akonadi-server/akonadi-server-1.3.0.ebuild,v 1.3 2010/02/08 21:38:18 alexxy Exp $

EAPI="2"

inherit cmake-utils

DESCRIPTION="The server part of Akonadi"
HOMEPAGE="http://pim.kde.org/akonadi"
SRC_URI="http://download.akonadi-project.org/${P/-server/}.tar.bz2"

LICENSE="LGPL-2.1"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"
SLOT="0"
IUSE="+mysql postgres sqlite"

RDEPEND="
	dev-libs/boost
	>=dev-libs/soprano-2.2
	>=x11-libs/qt-gui-4.5.0:4[dbus]
	>=x11-libs/qt-sql-4.5.0:4[mysql?,postgres?,sqlite?]
	x11-misc/shared-mime-info
"
DEPEND="${RDEPEND}
	dev-libs/libxslt
	>=kde-base/automoc-0.9.88
"

S="${WORKDIR}/${P/-server/}"

src_install() {
	# Set default storage backend in order: MySQL, PostgreSQL, SQLite
	if use mysql; then
		driver="QMYSQL"
	elif use postgres; then
		driver="QPSQL"
	elif use sqlite; then
		driver="QSQLITE"
	fi
	# Who knows, maybe it accidentally fixes our permission issues
	mkdir -p "${D}"/usr/share/config/akonadi || die "mkdir failed"
	cat <<-EOF > "${D}"/usr/share/config/akonadi/akonadiserverrc
[%General]
Driver=${driver}
EOF

	cmake-utils_src_install
}

pkg_postinst() {
	if use mysql || use postgres || use sqlite; then
		local func=elog
		( use postgres || use sqlite ) && func=ewarn
		echo
		${func} "${driver} has been set as your default akonadi storage backend."
		${func} "You can override it in your ~/.config/akonadi/akonadiserverrc."
		${func} "Available drivers are:"
		${func} "QMYSQL, QPSQL (testing), QSQLITE (experimental)"
		${func} "Be advised that QMYSQL is the one fully tested and officially supported."
		use sqlite && ewarn "If you experience random data losses using QSQLITE driver, you have been warned."
		echo
	else
		echo
		ewarn "You have decided to build akonadi-server with"
		ewarn "'mysql', 'postgres' and 'sqlite' USE flags disabled."
		ewarn "akonadi-server will not be functional."
		echo
	fi
}
