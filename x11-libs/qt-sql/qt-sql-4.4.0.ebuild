# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/qt-sql/qt-sql-4.4.0.ebuild,v 1.2 2008/05/19 20:26:17 dev-zero Exp $

EAPI="1"
inherit qt4-build

DESCRIPTION="The SQL module for the Qt toolkit."
HOMEPAGE="http://www.trolltech.com/"

LICENSE="|| ( QPL-1.0 GPL-3 GPL-2 )"
SLOT="4"
KEYWORDS="~amd64 ~x86"

IUSE="firebird mysql odbc postgres +qt3support +sqlite"

DEPEND="
	~x11-libs/qt-core-${PV}
	firebird? ( dev-db/firebird )
	sqlite? ( dev-db/sqlite:3 )
	mysql? ( virtual/mysql )
	postgres? ( virtual/postgresql-base
		dev-db/postgresql )
	odbc? ( dev-db/unixODBC )"
RDEPEND="${DEPEND}"

QT4_TARGET_DIRECTORIES="src/sql src/plugins/sqldrivers"
QT4_EXTRACT_DIRECTORIES="${QT4_TARGET_DIRECTORIES}"

pkg_setup() {
	if ! (use firebird || use mysql || use odbc || use postgres || use sqlite); then
		ewarn "You need to enable at least one SQL driver. Enable at least"
		ewarn "one of these USE flags: \"firebird mysql odbc postgres sqlite\""
		die "Enable at least one SQL driver."
	fi

	use qt3support && QT4_BUILT_WITH_USE_CHECK="${QT4_BUILT_WITH_USE_CHECK}
		~x11-libs/qt-core-${PV} qt3support"

	qt4-build_pkg_setup
}

src_compile() {
	local myconf
	# Don't support sqlite2 anymore
	myconf="${myconf} -no-sql-sqlite2
		$(qt_use mysql sql-mysql plugin) $(use mysql && echo "-I/usr/include/mysql -L/usr/$(get_libdir)/mysql ")
		$(qt_use postgres sql-psql plugin) $(use postgres && echo "-I/usr/include/postgresql/pgsql ")
		$(qt_use sqlite sql-sqlite plugin) $(use sqlite && echo '-system-sqlite')
		$(qt_use odbc sql-odbc plugin)
		$(qt_use qt3support)"

	myconf="${myconf} -no-xkb -no-tablet -no-fontconfig -no-xrender -no-xrandr
		-no-xfixes -no-xcursor -no-xinerama -no-xshape -no-sm -no-opengl
		-no-nas-sound -no-dbus -iconv -no-cups -no-nis -no-gif -no-libpng
		-no-libmng -no-libjpeg -no-openssl -system-zlib -no-webkit -no-phonon
		-no-xmlpatterns -no-freetype -no-libtiff  -no-accessibility -no-fontconfig
		-no-glib -no-opengl -no-svg"

	qt4-build_src_compile
}
