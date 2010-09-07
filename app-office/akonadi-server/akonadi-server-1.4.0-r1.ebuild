# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-office/akonadi-server/akonadi-server-1.4.0-r1.ebuild,v 1.1 2010/09/07 17:45:48 reavertm Exp $

EAPI="2"

inherit cmake-utils

DESCRIPTION="The server part of Akonadi"
HOMEPAGE="http://pim.kde.org/akonadi"
SRC_URI="http://download.akonadi-project.org/${P/-server/}.tar.bz2"

LICENSE="LGPL-2.1"
KEYWORDS="~amd64 ~arm ~hppa ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
SLOT="0"
IUSE="mysql postgres +sqlite +server"

CDEPEND="
	dev-libs/boost
	>=dev-libs/soprano-2.2
	>=x11-libs/qt-gui-4.5.0:4[dbus]
	>=x11-libs/qt-sql-4.5.0:4[mysql?,postgres?]
	>=x11-libs/qt-test-4.5.0:4
	x11-misc/shared-mime-info
"
DEPEND="${CDEPEND}
	dev-libs/libxslt
	>=dev-util/automoc-0.9.88
"
RDEPEND="${CDEPEND}
	server? (
		postgres? ( dev-db/postgresql-server )
	)
"

S="${WORKDIR}/${P/-server/}"

pkg_setup() {
	# Set default storage backend in order: SQLite, MySQL, PostgreSQL
	local available
	if use sqlite; then
		driver="QSQLITE3"
		available+=" ${driver}"
	elif use mysql; then
		driver="QMYSQL"
		available+=" ${driver}"
	elif use postgres; then
		driver="QPSQL"
		available+=" ${driver}"
	fi

	# Notify about driver name change
	if use sqlite && has_version "<=${CATEGORY}/${PN}-1.4.0[sqlite]"; then
		ewarn
		ewarn "SQLite driver name changed from QSQLITE to QSQLITE3."
		ewarn "Please edit your ~/.config/akonadi/akonadiserverrc."
	fi

	# Notify about MySQL not being default anymore
	if ! use mysql && has_version "<=${CATEGORY}/${PN}-1.4.0[mysql]"; then
		ewarn
		ewarn "MySQL driver is not enabled by default in Gentoo anymore."
		ewarn "If you intend to use it, please enable mysql USE flag and reinstall"
		ewarn "${CATEGORY}/${PN}."
		ewarn "Otherwise select different driver in your ~/.config/akonadi/akonadiserverrc."
		ewarn "Available drivers are:${available}"
	fi
}

src_install() {
	# Who knows, maybe it accidentally fixes our permission issues
	cat <<-EOF > "${T}"/akonadiserverrc
[%General]
Driver=${driver}
EOF
	insinto /usr/share/config/akonadi
	doins "${T}"/akonadiserverrc || die "doins failed"

	cmake-utils_src_install
}

pkg_postinst() {
	if use mysql || use postgres || use sqlite; then
		elog
		elog "${driver} has been set as your default akonadi storage backend."
		elog "You can override it in your ~/.config/akonadi/akonadiserverrc."
		elog "Available drivers are: QMYSQL, QPSQL, QSQLITE3"
	else
		ewarn
		ewarn "You have decided to build ${PN} with"
		ewarn "'mysql', 'postgres' and 'sqlite' USE flags disabled."
		ewarn "${PN} will not be functional."
	fi
}
