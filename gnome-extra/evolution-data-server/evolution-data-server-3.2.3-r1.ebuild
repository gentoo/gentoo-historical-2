# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/evolution-data-server/evolution-data-server-3.2.3-r1.ebuild,v 1.1 2012/02/24 23:22:11 tetromino Exp $

EAPI="4"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit autotools db-use eutils flag-o-matic gnome2 versionator virtualx

DESCRIPTION="Evolution groupware backend"
HOMEPAGE="http://www.gnome.org/projects/evolution/"

LICENSE="LGPL-2 BSD DB"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~ia64-linux ~x86-linux ~x86-solaris"
IUSE="doc +gnome-online-accounts +introspection ipv6 ldap kerberos vala +weather"

# GNOME3: How do we slot libedataserverui-3.0.so?
# Also, libedata-cal-1.2.so and libecal-1.2.so use gtk-3, but aren't slotted
RDEPEND=">=dev-libs/glib-2.28:2
	>=x11-libs/gtk+-3.0:3
	>=gnome-base/gconf-2
	>=dev-db/sqlite-3.5
	>=dev-libs/libgdata-0.9.1
	>=gnome-base/gnome-keyring-2.20.1
	>=dev-libs/libical-0.43
	>=net-libs/libsoup-2.31.2:2.4
	>=dev-libs/libxml2-2
	>=dev-libs/nspr-4.4
	>=dev-libs/nss-3.9
	>=sys-libs/db-4
	sys-libs/zlib
	virtual/libiconv
	gnome-online-accounts? (
		>=net-libs/gnome-online-accounts-3.1.1
		>=net-libs/liboauth-0.9.4 )
	introspection? ( >=dev-libs/gobject-introspection-0.9.12 )
	kerberos? ( virtual/krb5 )
	ldap? ( >=net-nds/openldap-2 )
	weather? ( >=dev-libs/libgweather-2.90.0:2 )
"
DEPEND="${RDEPEND}
	dev-lang/perl
	dev-util/gperf
	>=dev-util/pkgconfig-0.9
	>=dev-util/intltool-0.35.5
	sys-devel/bison
	>=gnome-base/gnome-common-2
	>=dev-util/gtk-doc-am-1.9
	>=sys-devel/gettext-0.17
	doc? ( >=dev-util/gtk-doc-1.9 )
	vala? ( >=dev-lang/vala-0.13.0:0.14[vapigen] )"
# eautoreconf needs:
#	>=gnome-base/gnome-common-2
#	>=dev-util/gtk-doc-am-1.9

REQUIRED_USE="vala? ( introspection )"

# FIXME
RESTRICT="test"

pkg_setup() {
	DOCS="ChangeLog MAINTAINERS NEWS TODO"
	# Uh, what to do about dbus-call-timeout ?
	# Fails to build with --disable-ssl; bug #392679, https://bugzilla.gnome.org/show_bug.cgi?id=642984
	G2CONF="${G2CONF}
		VALAC=$(type -P valac-0.14)
		VAPIGEN=$(type -P vapigen-0.14)
		$(use_enable gnome-online-accounts goa)
		$(use_enable introspection)
		$(use_enable ipv6)
		$(use_with kerberos krb5 ${EPREFIX}/usr)
		$(use_with ldap openldap)
		$(use_enable vala vala-bindings)
		$(use_enable weather)
		--enable-calendar
		--enable-largefile
		--enable-nntp
		--enable-ssl
		--enable-smime
		--with-libdb=${EPREFIX}/usr"
}

src_prepare() {
	# fix linking with glib-2.31, bug #395777
	epatch "${FILESDIR}/${PN}-3.2.2-gmodule-explicit.patch"
	epatch "${FILESDIR}/${PN}-3.2.2-g_thread_init.patch"
	# fix caldav quoting problems with libical-0.48, bug #405647
	epatch "${FILESDIR}/${P}-caldav-cannot-modify.patch"

	eautoreconf

	gnome2_src_prepare

	# GNOME bug 611353 (skips failing test atm)
	# XXX: uncomment when there's a proper fix
	#epatch "${FILESDIR}/e-d-s-camel-skip-failing-test.patch"

	# GNOME bug 621763 (skip failing test-ebook-stress-factory--fifo)
	#sed -e 's/\(SUBDIRS =.*\)ebook/\1/' \
	#	-i addressbook/tests/Makefile.{am,in} \
	#	|| die "failing test sed 1 failed"

	# /usr/include/db.h is always db-1 on FreeBSD
	# so include the right dir in CPPFLAGS
	append-cppflags "-I$(db_includedir)"
}

src_install() {
	# Prevent this evolution-data-server from linking to libs in the installed
	# evolution-data-server libraries by adding -L arguments for build dirs to
	# every .la file's relink_command field, forcing libtool to look there
	# first during relinking. This will mangle the .la files installed by
	# make install, but we don't care because we will be punting them anyway.
	perl "${FILESDIR}/fix_relink_command.pl" . ||
		die "fix_relink_command.pl failed"
	gnome2_src_install

	if use ldap; then
		MY_MAJORV=$(get_version_component_range 1-2)
		insinto /etc/openldap/schema
		doins "${FILESDIR}"/calentry.schema || die "doins failed"
		dosym /usr/share/${PN}-${MY_MAJORV}/evolutionperson.schema /etc/openldap/schema/evolutionperson.schema
	fi
}

src_test() {
	unset DBUS_SESSION_BUS_ADDRESS
	unset ORBIT_SOCKETDIR
	unset SESSION_MANAGER
	export XDG_DATA_HOME="${T}"
	unset DISPLAY
	Xemake check || die "Tests failed."
}

pkg_postinst() {
	gnome2_pkg_postinst

	if use ldap; then
		elog ""
		elog "LDAP schemas needed by evolution are installed in /etc/openldap/schema"
	fi
}
