# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/evolution-data-server/evolution-data-server-2.30.1-r1.ebuild,v 1.1 2010/06/13 19:03:53 pacho Exp $

EAPI="2"

inherit db-use eutils flag-o-matic gnome2 versionator virtualx autotools

DESCRIPTION="Evolution groupware backend"
HOMEPAGE="http://www.gnome.org/projects/evolution/"

LICENSE="LGPL-2 BSD DB"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~ia64-linux ~x86-linux ~x86-solaris"

SRC_URI="${SRC_URI}
	mirror://gentoo/${P}-patches.tar.bz2"

IUSE="doc ipv6 kerberos gnome-keyring ldap nntp ssl"

RDEPEND=">=dev-libs/glib-2.16.1
	>=x11-libs/gtk+-2.18
	>=gnome-base/gconf-2
	>=dev-db/sqlite-3.5
	>=dev-libs/libxml2-2
	>=net-libs/libsoup-2.3
	>=dev-libs/libgweather-2.25.4
	>=dev-libs/libical-0.43
	>=dev-libs/dbus-glib-0.6
	gnome-keyring? ( >=gnome-base/gnome-keyring-2.20.1 )
	>=sys-libs/db-4
	virtual/libiconv
	ssl? (
		>=dev-libs/nspr-4.4
		>=dev-libs/nss-3.9 )
	sys-libs/zlib

	ldap? ( >=net-nds/openldap-2.0 )
	kerberos? ( virtual/krb5 )"

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.9
	>=dev-util/intltool-0.35.5
	>=gnome-base/gnome-common-2
	>=dev-util/gtk-doc-am-1.9
	sys-devel/bison
	doc? ( >=dev-util/gtk-doc-1.9 )"

DOCS="ChangeLog MAINTAINERS NEWS TODO"

pkg_setup() {
	G2CONF="${G2CONF}
		$(use_with kerberos krb5 /usr)
		$(use_with ldap openldap)
		$(use_enable gnome-keyring)
		$(use_enable ipv6)
		$(use_enable nntp)
		$(use_enable ssl ssl)
		$(use_enable ssl smime)
		--with-weather
		--enable-largefile
		--with-libdb=/usr/$(get_libdir)"
}

src_prepare() {
	gnome2_src_prepare

	# Adjust to gentoo's /etc/service
	epatch "${FILESDIR}/${PN}-2.28.0-gentoo_etc_services.patch"

	# Rewind in camel-disco-diary to fix a crash
	epatch "${FILESDIR}/${PN}-1.8.0-camel-rewind.patch"

	# GNOME bug 611353 (skips failing test atm)
	epatch "${FILESDIR}/e-d-s-camel-skip-failing-test.patch"

	# Apply upstream patches committed to gnome-2-30 branch
	epatch "${WORKDIR}"/${P}-patches/*.patch

	if use doc; then
		sed "/^TARGET_DIR/i \GTKDOC_REBASE=/usr/bin/gtkdoc-rebase" \
			-i gtk-doc.make || die "sed 1 failed"
	else
		sed "/^TARGET_DIR/i \GTKDOC_REBASE=$(type -P true)" \
			-i gtk-doc.make || die "sed 2 failed"
	fi

	# /usr/include/db.h is always db-1 on FreeBSD
	# so include the right dir in CPPFLAGS
	append-cppflags "-I$(db_includedir)"

	# FIXME: Fix compilation flags crazyness
	sed 's/CFLAGS="$CFLAGS $WARNING_FLAGS"//' \
		-i configure.ac configure || die "sed 3 failed"

	# Fix intltoolize broken file, see upstream #577133
	sed "s:'\^\$\$lang\$\$':\^\$\$lang\$\$:g" -i po/Makefile.in.in \
		|| die "intltool rules fix failed"

	eautoreconf
}

src_install() {
	gnome2_src_install

	if use ldap; then
		MY_MAJORV=$(get_version_component_range 1-2)
		insinto /etc/openldap/schema
		doins "${FILESDIR}"/calentry.schema || die "doins failed"
		dosym /usr/share/${PN}-${MY_MAJORV}/evolutionperson.schema /etc/openldap/schema/evolutionperson.schema
	fi
}

src_test() {
	Xemake check || die "Tests failed."
}

pkg_preinst() {
	gnome2_pkg_preinst
	preserve_old_lib /usr/$(get_libdir)/libedataserver-1.2.so.11
}

pkg_postinst() {
	gnome2_pkg_postinst

	if use ldap; then
		elog ""
		elog "LDAP schemas needed by evolution are installed in /etc/openldap/schema"
	fi

	preserve_old_lib_notify /usr/$(get_libdir)/libedataserver-1.2.so.11
}
