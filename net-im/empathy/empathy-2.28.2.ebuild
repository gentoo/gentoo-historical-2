# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/empathy/empathy-2.28.2.ebuild,v 1.5 2010/04/16 18:25:38 armin76 Exp $

EAPI="2"

inherit eutils gnome2 multilib

DESCRIPTION="Telepathy client and library using GTK+"
HOMEPAGE="http://live.gnome.org/Empathy"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~sparc ~x86"
# FIXME: Add location support once geoclue stops being idiotic with automagic deps
IUSE="applet networkmanager python spell test webkit" # map

# FIXME: libnotify & libcanberra hard deps
RDEPEND=">=dev-libs/glib-2.16.0
	>=x11-libs/gtk+-2.16.0
	>=gnome-base/gconf-2
	>=dev-libs/dbus-glib-0.51
	>=gnome-extra/evolution-data-server-1.2
	>=net-libs/telepathy-glib-0.7.35
	>=media-libs/libcanberra-0.4[gtk]
	>=x11-libs/libnotify-0.4.4
	>=gnome-base/gnome-keyring-2.22

	dev-libs/libunique
	net-libs/farsight2
	media-libs/gstreamer:0.10
	media-libs/gst-plugins-base:0.10
	net-libs/telepathy-farsight
	dev-libs/libxml2
	x11-libs/libX11
	net-voip/telepathy-connection-managers

	applet? ( >=gnome-base/gnome-panel-2.10 )
	networkmanager? ( =net-misc/networkmanager-0.7* )
	python? (
		>=dev-lang/python-2.4.4-r5
		>=dev-python/pygtk-2 )
	spell? (
		app-text/enchant
		app-text/iso-codes )
	webkit? ( >=net-libs/webkit-gtk-1.1.7 )
"
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

# FIXME: Highly broken with parallel make, mallard strike 2, see bug #286889
MAKEOPTS="${MAKEOPTS} -j1"

pkg_setup() {
	G2CONF="${G2CONF}
		--disable-maintainer-mode
		--disable-static
		--disable-location
		--disable-gtk-doc
		--disable-map
		$(use_enable applet megaphone)
		$(use_enable applet nothere)
		$(use_enable debug)
		$(use_with networkmanager connectivity nm)
		$(use_enable python)
		$(use_enable spell)
		$(use_enable test coding-style-checks)
		$(use_enable webkit)
	"
}

src_prepare() {
	gnome2_src_prepare

	# Remove hard enabled -Werror (see AM_MAINTAINER_MODE), bug 218687
	sed -i "s:-Werror::g" configure || die "sed 1 failed"
}

src_test() {
	unset DBUS_SESSION_BUS_ADDRESS
	emake check || die "emake check failed."
}

pkg_preinst() {
	gnome2_pkg_preinst
	preserve_old_lib /usr/$(get_libdir)/libempathy.so.23
	preserve_old_lib /usr/$(get_libdir)/libempathy-gtk.so.19
}

pkg_postinst() {
	gnome2_pkg_postinst
	echo
	elog "Empathy needs telepathy's connection managers to use any IM protocol."
	elog "See the USE flags on net-voip/telepathy-connection-managers"
	elog "to install them."
	preserve_old_lib_notify /usr/$(get_libdir)/libempathy.so.23
	preserve_old_lib_notify /usr/$(get_libdir)/libempathy-gtk.so.19
}
