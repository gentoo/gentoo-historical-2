# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/libgda/libgda-1.2.4.ebuild,v 1.3 2007/07/12 04:19:34 mr_bones_ Exp $

WANT_AUTOMAKE="1.9"
WANT_AUTOCONF="2.5"

inherit autotools eutils gnome2

DESCRIPTION="Gnome Database Access Library"
HOMEPAGE="http://www.gnome-db.org/"
LICENSE="GPL-2 LGPL-2"

IUSE="berkdb doc firebird freetds ldap mdb mysql oci8 odbc postgres sqlite3 xbase"
SLOT="1"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"

RDEPEND=">=dev-libs/glib-2
	>=dev-libs/libxml2-2
	>=dev-libs/libxslt-1.0.9
	sys-libs/readline
	sys-libs/ncurses
	dev-libs/popt
	berkdb? ( sys-libs/db )
	odbc? ( >=dev-db/unixODBC-2.0.6 )
	mysql? ( virtual/mysql )
	postgres? ( >=dev-db/libpq-7.2.1 )
	freetds? ( >=dev-db/freetds-0.62 )
	x86? ( firebird? ( dev-db/firebird ) )
	xbase? ( dev-db/xbase )
	sqlite3? ( >=dev-db/sqlite-3 )
	mdb? ( >=app-office/mdbtools-0.5 )
	ldap? ( >=net-nds/openldap-2.0.25 )"

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.9
	>=dev-util/intltool-0.30
	app-text/scrollkeeper
	doc? ( >=dev-util/gtk-doc-1 )"

DOCS="AUTHORS ChangeLog NEWS README"
USE_DESTDIR="1"

# problems with parallel builds
MAKEOPTS="${MAKEOPTS} -j1"

pkg_setup() {
	G2CONF="$(use_with berkdb bdb /usr)    \
		$(use_with firebird firebird /usr) \
		$(use_with freetds tds /usr)       \
		$(use_with ldap ldap /usr)         \
		$(use_with mdb mdb /usr)           \
		$(use_with mysql mysql /usr)       \
		$(use_with odbc odbc /usr)         \
		$(use_with postgres postgres /usr) \
		$(use_with sqlite3 sqlite /usr)     \
		$(use_with xbase xbase /usr)"

	use oci8 || G2CONF="${G2CONF} --without-oracle"

	# not in portage
	G2CONF="${G2CONF} --without-msql --without-sybase --without-ibmdb2"
}

src_unpack() {
	gnome2_src_unpack

	# Fix freetds API problems
	epatch "${FILESDIR}"/${P}-freetds_api_fixes.patch
	# Fix compilation of the mdb provider
	epatch "${FILESDIR}"/${PN}-1.2.3-mdb_api.patch

	sed -n -e '/GTK_DOC_CHECK/,/IT_PROG_INTLTOOL/p' aclocal.m4 > gtk-doc.m4
	intltoolize --automake -c -f || die "intltoolize failed"
	AT_M4DIR="." eautoreconf
}
