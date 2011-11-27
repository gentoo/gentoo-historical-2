# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/empathy/empathy-3.2.2.ebuild,v 1.1 2011/11/27 19:06:08 eva Exp $

EAPI="4"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"
PYTHON_DEPEND="2:2.4"

inherit gnome2 python

DESCRIPTION="Telepathy client and library using GTK+"
HOMEPAGE="http://live.gnome.org/Empathy"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-linux"
IUSE="call debug eds +map +geoloc gnome-online-accounts +networkmanager sendto spell test +v4l"

# FIXME: gst-plugins-bad is required for the valve plugin. This should move to good
# eventually at which point the dep can be dropped
# libgee extensively used in libempathy
# gdk-pixbuf and pango extensively used in libempathy-gtk
RDEPEND=">=dev-libs/glib-2.28:2
	x11-libs/gdk-pixbuf:2
	>=x11-libs/gtk+-3.0.2:3
	x11-libs/pango
	>=dev-libs/dbus-glib-0.51
	>=dev-libs/folks-0.6.2
	dev-libs/libgee:0
	>=gnome-base/gnome-keyring-2.91.4-r300
	>=media-libs/libcanberra-0.25[gtk3]
	media-sound/pulseaudio[glib]
	>=net-libs/gnutls-2.8.5
	>=net-libs/telepathy-glib-0.16.0
	>=net-libs/webkit-gtk-1.3.13:3
	>=x11-libs/libnotify-0.7

	dev-libs/libxml2:2
	gnome-base/gsettings-desktop-schemas
	media-libs/gstreamer:0.10
	media-libs/gst-plugins-base:0.10
	media-libs/gst-plugins-bad
	>=net-im/telepathy-logger-0.2.8
	net-libs/farsight2
	>=net-libs/telepathy-farsight-0.0.14
	net-im/telepathy-connection-managers
	x11-libs/libX11

	call? (
		>=media-libs/clutter-1.7.14:1.0
		>=media-libs/clutter-gtk-0.90.3:1.0
		media-libs/clutter-gst:1.0
		net-libs/telepathy-farstream )
	eds? ( >=gnome-extra/evolution-data-server-1.2 )
	geoloc? ( >=app-misc/geoclue-0.11 )
	gnome-online-accounts? ( net-libs/gnome-online-accounts )
	map? (
		>=media-libs/clutter-1.7.14:1.0
		>=media-libs/clutter-gtk-0.90.3:1.0
		media-libs/libchamplain:0.12[gtk] )
	networkmanager? ( >=net-misc/networkmanager-0.7 )
	sendto? ( >=gnome-extra/nautilus-sendto-2.90.0 )
	spell? (
		>=app-text/enchant-1.2
		>=app-text/iso-codes-0.35 )
	v4l? (
		|| ( sys-fs/udev[gudev] sys-fs/udev[extras] )
		media-plugins/gst-plugins-v4l2:0.10
		>=media-video/cheese-2.91.91.1 )
"
DEPEND="${RDEPEND}
	app-text/scrollkeeper
	>=app-text/gnome-doc-utils-0.17.3
	>=dev-util/intltool-0.35.0
	>=dev-util/pkgconfig-0.16
	>=sys-devel/gettext-0.17
	test? (
		sys-apps/grep
		>=dev-libs/check-0.9.4 )
	dev-libs/libxslt
"
PDEPEND=">=net-im/telepathy-mission-control-5.7.6"

pkg_setup() {
	DOCS="CONTRIBUTORS AUTHORS ChangeLog NEWS README"
	G2CONF="${G2CONF}
		--disable-coding-style-checks
		--disable-schemas-compile
		--disable-static
		--disable-meego
		--disable-Werror
		$(use_enable call)
		$(use_enable debug)
		$(use_with eds)
		$(use_enable geoloc location)
		$(use_enable gnome-online-accounts goa)
		$(use_enable map)
		$(use_with networkmanager connectivity nm)
		$(use_enable sendto nautilus-sendto)
		$(use_enable spell)
		$(use_with v4l cheese)
		$(use_enable v4l gudev)"

	# Build time python tools need python2
	python_set_active_version 2
	python_pkg_setup
}

src_test() {
	unset DBUS_SESSION_BUS_ADDRESS
	emake check
}

pkg_postinst() {
	gnome2_pkg_postinst
	elog "Empathy needs telepathy's connection managers to use any IM protocol."
	elog "See the USE flags on net-im/telepathy-connection-managers"
	elog "to install them."
}
