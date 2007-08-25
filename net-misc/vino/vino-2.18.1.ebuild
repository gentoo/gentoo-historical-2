# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/vino/vino-2.18.1.ebuild,v 1.10 2007/08/25 14:34:26 vapier Exp $

WANT_AUTOCONF=latest
WANT_AUTOMAKE=1.9
inherit eutils gnome2 autotools

DESCRIPTION="An integrated VNC server for GNOME"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm ~hppa ia64 ppc ~ppc64 sparc x86 ~x86-fbsd"
IUSE="avahi crypt gnutls jpeg keyring libnotify zlib"

RDEPEND=">=dev-libs/glib-2.12
	>=x11-libs/gtk+-2.10
	>=gnome-base/gconf-2
	>=gnome-base/libglade-2
	>=gnome-base/libgnomeui-2.5.2
	dev-libs/dbus-glib
	>=gnome-base/orbit-2
	>=gnome-base/libbonobo-2
	x11-libs/libXtst
	libnotify? ( >=x11-libs/libnotify-0.4.3 )
	keyring? ( gnome-base/gnome-keyring )
	avahi? ( >=net-dns/avahi-0.6 )
	crypt? ( >=dev-libs/libgcrypt-1.1.90 )
	gnutls? ( >=net-libs/gnutls-1 )
	jpeg? ( media-libs/jpeg )
	zlib? ( sys-libs/zlib )"
DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.9
	>=dev-util/intltool-0.35"

DOCS="AUTHORS ChangeLog MAINTAINERS NEWS README"

pkg_setup() {
	if use avahi && ! built_with_use net-dns/avahi dbus; then
		einfo "avahi support in vino requires USE=dbus in avahi"
		die "Please rebuild net-dns/avahi with USE=dbus"
	fi
	G2CONF="$(use_with jpeg) $(use_enable gnutls) $(use_enable crypt gcrypt) \
			$(use_with zlib) $(use_with zlib libz) $(use_enable avahi) \
			$(use_enable libnotify) $(use_enable keyring gnome-keyring) \
			--enable-session-support"
}
