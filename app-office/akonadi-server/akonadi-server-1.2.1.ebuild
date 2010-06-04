# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-office/akonadi-server/akonadi-server-1.2.1.ebuild,v 1.13 2010/06/04 21:16:38 reavertm Exp $

EAPI="2"

inherit cmake-utils

DESCRIPTION="The server part of Akonadi"
HOMEPAGE="http://pim.kde.org/akonadi"
SRC_URI="http://download.akonadi-project.org/${P/-server/}.tar.bz2"

LICENSE="LGPL-2.1"
KEYWORDS="alpha amd64 ~arm hppa ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux"
SLOT="0"
IUSE="+mysql sqlite"

RDEPEND="
	dev-libs/boost
	>=dev-libs/soprano-2.2
	>=x11-libs/qt-gui-4.5.0:4[dbus]
	>=x11-libs/qt-sql-4.5.0:4[mysql?,sqlite?]
	>=x11-libs/qt-test-4.5.0:4
	x11-misc/shared-mime-info
"
DEPEND="${RDEPEND}
	dev-libs/libxslt
	>=dev-util/automoc-0.9.88
"

S="${WORKDIR}/${P/-server/}"

src_install() {
	# Set default storage backend in order: mysql, sqlite
	if use mysql; then
		driver="QMYSQL"
	elif use sqlite; then
		driver="QSQLITE"
	fi
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
	if use mysql || use sqlite; then
		local func=elog
		use sqlite && func=ewarn
		echo
		${func} "${driver} has been set as your default akonadi storage backend."
		${func} "You can override it in your ~/.config/akonadi/akonadiserverrc."
		${func} "Available drivers are:"
		${func} "QMYSQL, QSQLITE (experimental)"
		${func} "Be advised that QMYSQL is the one fully tested and officially supported."
		use sqlite && ewarn "If you experience random data losses using QSQLITE driver, you have been warned."
		echo
	else
		echo
		ewarn "You have decided to build akonadi-server with both"
		ewarn "'mysql' and 'sqlite' USE flags disabled."
		ewarn "akonadi-server will not be functional."
		echo
	fi
}
