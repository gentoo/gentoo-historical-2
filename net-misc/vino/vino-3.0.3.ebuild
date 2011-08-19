# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/vino/vino-3.0.3.ebuild,v 1.1 2011/08/19 14:29:25 nirbheek Exp $

EAPI="4"
GCONF_DEBUG="yes"
GNOME2_LA_PUNT="yes"

inherit gnome2
if [[ ${PV} = 9999 ]]; then
	inherit gnome2-live
fi

DESCRIPTION="An integrated VNC server for GNOME"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2"
SLOT="0"
if [[ ${PV} = 9999 ]]; then
	KEYWORDS=""
else
	KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
fi
IUSE="avahi crypt ipv6 jpeg gnome-keyring libnotify networkmanager ssl +telepathy +zlib"

RDEPEND=">=dev-libs/glib-2.26:2
	>=x11-libs/gtk+-3.0.0:3
	>=dev-libs/libgcrypt-1.1.90
	>=net-libs/libsoup-2.24:2.4

	dev-libs/dbus-glib
	x11-libs/pango[X]
	x11-libs/libX11
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXtst

	avahi? ( >=net-dns/avahi-0.6[dbus] )
	crypt? ( >=dev-libs/libgcrypt-1.1.90 )
	gnome-keyring? ( || ( gnome-base/libgnome-keyring <gnome-base/gnome-keyring-2.29.4 ) )
	jpeg? ( virtual/jpeg:0 )
	libnotify? ( >=x11-libs/libnotify-0.7.0 )
	networkmanager? ( >=net-misc/networkmanager-0.7 )
	ssl? ( >=net-libs/gnutls-1.0.0 )
	telepathy? ( >=net-libs/telepathy-glib-0.11.6 )
	zlib? ( sys-libs/zlib )"
DEPEND="${RDEPEND}
	>=dev-lang/perl-5
	>=dev-util/pkgconfig-0.16
	>=dev-util/intltool-0.40
	>=sys-devel/gettext-0.17
	|| (
		gnome-base/libgnome-keyring
		<gnome-base/gnome-keyring-2.29.4 )"
# keyring is always required at build time per bug 322763

pkg_setup() {
	G2CONF="${G2CONF}
		--disable-schemas-compile
		--disable-maintainer-mode
		--enable-http-server
		--with-gcrypt
		$(use_with avahi)
		$(use_with crypt gcrypt)
		$(use_enable ipv6)
		$(use_with jpeg)
		$(use_with gnome-keyring)
		$(use_with libnotify)
		$(use_with networkmanager network-manager)
		$(use_with ssl gnutls)
		$(use_with telepathy)
		$(use_with zlib)"
	DOCS="AUTHORS ChangeLog* NEWS README"
}
