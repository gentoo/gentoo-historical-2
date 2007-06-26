# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/evolution-data-server/evolution-data-server-1.10.1-r3.ebuild,v 1.2 2007/06/26 02:07:20 mr_bones_ Exp $

inherit db-use eutils flag-o-matic gnome2 autotools

DESCRIPTION="Evolution groupware backend"
HOMEPAGE="http://www.gnome.org/projects/evolution/"

LICENSE="LGPL-2 Sleepycat"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="doc ipv6 kerberos keyring krb4 ldap ssl"

RDEPEND=">=dev-libs/glib-2.10
	>=gnome-base/libbonobo-2.4.2
	>=gnome-base/orbit-2.9.8
	>=gnome-base/libgnomeui-2
	>=gnome-base/gnome-vfs-2
	>=gnome-base/libgnome-2
	>=gnome-base/gnome-common-2
	keyring? ( gnome-base/gnome-keyring )
	>=dev-libs/libxml2-2
	>=gnome-base/gconf-2
	>=x11-libs/gtk+-2
	>=gnome-base/libglade-2
	>=net-libs/libsoup-2.2.90
	sys-libs/zlib
	=sys-libs/db-4*
	ldap? ( >=net-nds/openldap-2.0 )
	ssl? (
		>=dev-libs/nspr-4.4
		>=dev-libs/nss-3.9 )
	kerberos? ( virtual/krb5 )
	krb4? ( virtual/krb5 )"

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.9
	>=dev-util/intltool-0.35.5
	doc? ( >=dev-util/gtk-doc-1.4 )"

DOCS="ChangeLog MAINTAINERS NEWS TODO"

RESTRICT="confcache"

pkg_setup() {
	G2CONF="$(use_with ldap openldap)       \
		$(use_with kerberos krb5 /usr)      \
		$(use_enable ssl nss)               \
		$(use_enable ssl smime)             \
		$(use_enable ipv6)                  \
		$(use_enable keyring gnome-keyring) \
		--with-libdb=/usr/$(get_libdir)"

	if use krb4 && ! built_with_use virtual/krb5 krb4; then
		ewarn
		ewarn "In order to add kerberos 4 support, you have to emerge"
		ewarn "virtual/krb5 with the 'krb4' USE flag enabled as well."
		ewarn
		ewarn "Skipping for now."
		ewarn
		G2CONF="${G2CONF} --without-krb4"
	else
		G2CONF="${G2CONF} $(use_with krb4 krb4 /usr)"
	fi
}

src_unpack() {
	gnome2_src_unpack

	# Fix what ?
	epatch ${FILESDIR}/${PN}-1.2.0-gentoo_etc_services.patch

	# Fix broken libdb build
	epatch "${FILESDIR}"/${PN}-1.7.3-libdb.patch

	# Resolve symbols at execution time for setgid binaries
	epatch "${FILESDIR}"/${PN}-no_lazy_bindings.patch

	# Rewind in camel-disco-diary to fix a crash
	epatch "${FILESDIR}"/${PN}-1.8.0-camel-rewind.patch

	# Fix vulnerability in APOP authentification; bug #174210
	epatch "${FILESDIR}"/${PN}-APOP-auth-fix.patch

	# Fix vulnerability in IMAP; bug #182011
	epatch "${FILESDIR}"/${PN}-1.10.1-imap-overflow.patch

#-------------Upstream GNOME look here -----------------#

	# --as-needed fixes
	epatch "${FILESDIR}"/${PN}-1.9.91-as-needed.patch

	# fix for dep ordering so we can add libedataserverui to libexchange-storage
	# we need to do this or: undefined reference to `e_passwords_get_password'
	# are the kinds of errors you will get.

	# move the groupwise backend and provider for addressbook, camel, and
	# calendar to its own folder called server.deps.
	mkdir server.deps
	mv addressbook/backends/groupwise server.deps/addressbook
	mv camel/providers/groupwise server.deps/camel
	mv calendar/backends/groupwise server.deps/calendar

	# now fix the autotools foo for the new directory and the removed ones
	echo "SUBDIRS = addressbook camel calendar" > server.deps/Makefile.am

	# remove groupwise folder from Makefile's since they are in a diff location
	sed -i -e 's: groupwise::' addressbook/backends/Makefile.am camel/providers/Makefile.am calendar/backends/Makefile.am

	# fix configure.in location of the Makefile's
	sed -i -e 's:addressbook/backends/groupwise:server.deps/addressbook:' configure.in
	sed -i -e 's:camel/providers/groupwise:server.deps/camel:' configure.in
	# tack on the server.deps Makefile on our last edit
	sed -i -e 's:calendar/backends/groupwise:server.deps/calendar/Makefile\nserver.deps:' configure.in

	# fix file includes
	sed -i -e 's:<backends/groupwise/e-book-backend-groupwise.h>:"server.deps/addressbook/e-book-backend-groupwise.h":' addressbook/libedata-book/e-data-book-factory.c

	# Fix db version for FreeBSD users where -ldb is always db-1
	sed -i -e "s:-ldb:-l$(db_libname):" configure.in

#---------------Upstream GNOME stop here---------------
	eautoreconf
}

src_compile() {
	# Use NSS/NSPR only if 'ssl' is enabled.
	if use ssl ; then
		sed -i -e "s|mozilla-nss|nss|
		s|mozilla-nspr|nspr|" ${S}/configure
		G2CONF="${G2CONF} --enable-nss=yes"
	else
		G2CONF="${G2CONF} --without-nspr-libs --without-nspr-includes \
		--without-nss-libs --without-nss-includes"
	fi

	# /usr/include/db.h is always db-1 on FreeBSD
	# so include the right dir in CPPFLAGS
	append-cppflags "-I$(db_includedir)"

	cd "${S}"
	gnome2_src_compile
}
