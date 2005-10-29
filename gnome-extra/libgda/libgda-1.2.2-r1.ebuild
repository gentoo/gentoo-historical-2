# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/libgda/libgda-1.2.2-r1.ebuild,v 1.7 2005/10/29 15:42:09 hansmi Exp $

inherit eutils gnome2

DESCRIPTION="Gnome Database Access Library"
HOMEPAGE="http://www.gnome-db.org/"
LICENSE="GPL-2 LGPL-2"

IUSE="berkdb doc firebird freetds ldap mdb mysql oci8 odbc postgres sqlite xbase"
SLOT="1"
KEYWORDS="alpha ~amd64 ppc ppc64 sparc x86"

RDEPEND=">=dev-libs/glib-2
	dev-libs/libxml2
	>=dev-libs/libxslt-1.0.9
	dev-libs/popt
	sys-libs/ncurses
	sys-libs/readline
	berkdb? ( sys-libs/db )
	freetds? ( >=dev-db/freetds-0.62 )
	ldap? ( >=net-nds/openldap-2.0.25 )
	mysql? ( >=dev-db/mysql-3.23.51 )
	odbc? ( >=dev-db/unixODBC-2.0.6 )
	postgres? ( >=dev-db/postgresql-7.2.1 )
	x86? ( firebird? ( dev-db/firebird ) )
	sqlite? ( >=dev-db/sqlite-3 )
	xbase? ( dev-db/xbase )
	mdb? ( >=app-office/mdbtools-0.5 )"

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
		$(use_with sqlite sqlite /usr)     \
		$(use_with xbase xbase /usr)"

	use oci8 || G2CONF="${G2CONF} --without-oracle"

	# not in portage
	G2CONF="${G2CONF} --without-msql --without-sybase --without-ibmdb2"
}

src_unpack() {
	unpack "${A}"
	cd "${S}"

	gnome2_omf_fix doc/Makefile.in

	# Fix syslog format string attack (bug #110467).
	epatch ${FILESDIR}/${PN}-1.2-syslog_format_fix.patch
	# Fix freetds API problems
	epatch ${FILESDIR}/${PN}-1.0.2-freetds_fix.patch
	epatch ${FILESDIR}/${PN}-1.2.2-freetds_fixes.patch
	# Fix compilation of the mdb provider
	epatch ${FILESDIR}/${PN}-1.2.1-mdb_fix.patch

	export WANT_AUTOMAKE=1.9
	sed -n -e '/GTK_DOC_CHECK/,/dnl IT_PROG_INTLTOOL/p' aclocal.m4 > gtkdoc.m4
	aclocal -I . || die "aclocal failed"
	libtoolize --copy --force
	autoconf || die "autoconf failed"
	automake || die "automake failed"
}
