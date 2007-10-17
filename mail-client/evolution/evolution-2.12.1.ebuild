# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-client/evolution/evolution-2.12.1.ebuild,v 1.1 2007/10/17 23:20:47 eva Exp $

inherit gnome2 flag-o-matic

DESCRIPTION="Integrated mail, addressbook and calendaring functionality"
HOMEPAGE="http://www.gnome.org/projects/evolution/"
SRC_URI="${SRC_URI}"

LICENSE="GPL-2 FDL-1.1"
SLOT="2.0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
# gstreamer for audio-inline, when it uses 0.10
IUSE="crypt dbus debug doc hal ipv6 kerberos krb4 ldap mono networkmanager nntp pda profile spell ssl"

# Pango dependency required to avoid font rendering problems
RDEPEND="
	>=x11-libs/gtk+-2.10
	>=gnome-extra/evolution-data-server-1.11.90
	>=x11-themes/gnome-icon-theme-1.2
	>=gnome-base/gnome-vfs-2.4
	>=gnome-base/libbonoboui-2.4.2
	>=gnome-base/libbonobo-2.4.2
	>=gnome-extra/gtkhtml-3.16
	>=gnome-base/gconf-2
	>=gnome-base/libglade-2
	>=gnome-base/libgnomecanvas-2
	>=gnome-base/libgnomeui-2
	>=dev-libs/libxml2-2
	dbus? ( dev-libs/dbus-glib )
	hal? ( >=sys-apps/hal-0.5.4 )
	x11-libs/libnotify
	pda? (
		>=app-pda/gnome-pilot-2.0.15
		>=app-pda/gnome-pilot-conduits-2 )
	dev-libs/atk
	ssl? (
		>=dev-libs/nspr-4.6.1
		>=dev-libs/nss-3.11 )
	networkmanager? ( net-misc/networkmanager )
	>=net-libs/libsoup-2.2.96
	kerberos? ( virtual/krb5 )
	krb4? ( virtual/krb5 )
	>=dev-libs/glib-2.10
	>=gnome-base/orbit-2.9.8
	spell? ( >=app-text/gnome-spell-1.0.5 )
	crypt? ( || ( >=app-crypt/gnupg-2.0.1-r2 =app-crypt/gnupg-1.4* ) )
	ldap? ( >=net-nds/openldap-2 )
	mono? ( >=dev-lang/mono-1 )"
#	gstreamer? (
#		>=media-libs/gstreamer-0.10
#		>=media-libs/gst-plugins-base-0.10 )

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.9
	>=dev-util/intltool-0.35.5
	sys-devel/gettext
	sys-devel/bison
	app-text/scrollkeeper
	>=gnome-base/gnome-common-2.12.0
	>=app-text/gnome-doc-utils-0.9.1
	doc? ( >=dev-util/gtk-doc-0.6 )"

DOCS="AUTHORS ChangeLog* HACKING MAINTAINERS NEWS* README"
ELTCONF="--reverse-deps"

pkg_setup() {
	G2CONF="--without-kde-applnk-path        \
		--enable-plugins=experimental    \
		$(use_enable ssl nss)            \
		$(use_enable ssl smime)          \
		$(use_enable ipv6)               \
		$(use_enable mono)               \
		$(use_enable nntp)               \
		$(use_enable pda pilot-conduits) \
		$(use_enable profile profiling)  \
		$(use_with ldap openldap)        \
		$(use_with kerberos krb5 /usr)"

	# We need a graphical pinentry frontend to be able to ask for the GPG
	# password from inside evolution, bug 160302
	if use crypt && has_version '>=app-crypt/gnupg-2.0.1-r2'; then
		if ! built_with_use -o app-crypt/pinentry gtk qt3; then
			die "You must build app-crypt/pinentry with GTK or QT3 support"
		fi
	fi

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

	# dang - I've changed this to do --enable-plugins=experimental.  This will autodetect
	# new-mail-notify and exchange, but that cannot be helped for the moment.
	# They should be changed to depend on a --enable-<foo> like mono is.  This
	# cleans up a ton of crap from this ebuild.
}

src_unpack() {
	gnome2_src_unpack

	# Mail-remote doesn't build
	epatch "${FILESDIR}"/${P}-mail-remote-broken.patch
}

src_compile() {
	# Use NSS/NSPR only if 'ssl' is enabled.
	if use ssl ; then
		sed -i -e "s|mozilla-nss|nss|
			s|mozilla-nspr|nspr|" "${S}"/configure
		G2CONF="${G2CONF} --enable-nss=yes"
	else
		G2CONF="${G2CONF} --without-nspr-libs --without-nspr-includes \
			--without-nss-libs --without-nss-includes"
	fi

	# problems with -O3 on gcc-3.3.1
	replace-flags -O3 -O2

	if [ "${ARCH}" = "hppa" ]; then
		append-flags "-fPIC -ffunction-sections"
		export LDFLAGS="-ffunction-sections -Wl,--stub-group-size=25000"
	fi

	gnome2_src_compile
}

pkg_postinst() {
	gnome2_pkg_postinst

	elog "To change the default browser if you are not using GNOME, do:"
	elog "gconftool-2 --set /desktop/gnome/url-handlers/http/command -t string 'mozilla %s'"
	elog "gconftool-2 --set /desktop/gnome/url-handlers/https/command -t string 'mozilla %s'"
	elog ""
	elog "Replace 'mozilla %s' with which ever browser you use."
	elog ""
	elog "Junk filters are now a run-time choice. You will get a choice of"
	elog "bogofilter or spamassassin based on which you have installed"
	elog ""
	elog "You have to install one of these for the spam filtering to actually work"
}
