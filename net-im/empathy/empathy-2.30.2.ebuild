# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/empathy/empathy-2.30.2.ebuild,v 1.4 2010/08/22 20:40:11 eva Exp $

EAPI="2"

inherit gnome2 multilib

DESCRIPTION="Telepathy client and library using GTK+"
HOMEPAGE="http://live.gnome.org/Empathy"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~ia64 ~ppc ~sparc x86"
# FIXME: Add location support once geoclue stops being idiotic with automagic deps
IUSE="nautilus networkmanager spell test webkit" # map

# FIXME: libnotify & libcanberra hard deps
RDEPEND=">=dev-libs/glib-2.22.0
	>=x11-libs/gtk+-2.18.0
	>=gnome-base/gconf-2
	>=dev-libs/dbus-glib-0.51
	>=gnome-extra/evolution-data-server-1.2
	>=net-libs/telepathy-glib-0.9.2
	>=media-libs/libcanberra-0.4[gtk]
	>=x11-libs/libnotify-0.4.4
	>=gnome-base/gnome-keyring-2.22

	>=dev-libs/libunique-1.1.6
	net-libs/farsight2
	media-libs/gstreamer:0.10
	media-libs/gst-plugins-base:0.10
	net-libs/telepathy-farsight
	dev-libs/libxml2
	x11-libs/libX11
	net-voip/telepathy-connection-managers

	nautilus? ( || (
		>=gnome-extra/nautilus-sendto-2.28.1[-empathy]
		>=gnome-extra/nautilus-sendto-2.28.4-r1 ) )
	networkmanager? ( >=net-misc/networkmanager-0.7 )
	spell? (
		app-text/enchant
		app-text/iso-codes )
	webkit? ( >=net-libs/webkit-gtk-1.1.15 )"
#	Upstream says not to ship this, or use this.  It is also buggy.
#	tpl? ( >=net-im/telepathy-logger-0.1.1 )
#	map? (
#		>=media-libs/libchamplain-0.4[gtk]
#		>=media-libs/clutter-gtk-0.10:1.0 )
DEPEND="${RDEPEND}
	app-text/scrollkeeper
	>=app-text/gnome-doc-utils-0.17.3
	>=dev-util/intltool-0.35.0
	>=dev-util/pkgconfig-0.16
	test? (
		sys-apps/grep
		>=dev-libs/check-0.9.4 )
	dev-libs/libxslt
	virtual/python
"
PDEPEND=">=net-im/telepathy-mission-control-5"

DOCS="CONTRIBUTORS AUTHORS ChangeLog NEWS README"

pkg_setup() {
	# Hard disable favourite_contacts and tpl, TpLogger is buggy.
	G2CONF="${G2CONF}
		--disable-maintainer-mode
		--disable-static
		--disable-location
		--disable-map
		--disable-control-center-embedding
		--disable-Werror
		--disable-favourite_contacts
		--disable-tpl
		$(use_enable debug)
		$(use_enable nautilus nautilus-sendto)
		$(use_with networkmanager connectivity nm)
		$(use_enable spell)
		$(use_enable test coding-style-checks)
		$(use_enable webkit)"
}

src_test() {
	unset DBUS_SESSION_BUS_ADDRESS
	emake check || die "emake check failed."
}

pkg_postinst() {
	gnome2_pkg_postinst
	echo
	elog "Empathy needs telepathy's connection managers to use any IM protocol."
	elog "See the USE flags on net-voip/telepathy-connection-managers"
	elog "to install them."
}
