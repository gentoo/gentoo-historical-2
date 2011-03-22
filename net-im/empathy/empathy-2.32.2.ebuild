# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/empathy/empathy-2.32.2.ebuild,v 1.14 2011/03/22 19:40:56 ranger Exp $

EAPI="3"
GCONF_DEBUG="yes"
PYTHON_DEPEND="2:2.4"

inherit eutils gnome2 multilib python

DESCRIPTION="Telepathy client and library using GTK+"
HOMEPAGE="http://live.gnome.org/Empathy"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~ia64 ppc ~sparc x86"
# FIXME: Add location support once geoclue stops being idiotic with automagic deps
IUSE="eds nautilus networkmanager spell test webkit" # map

# FIXME: libnotify & libcanberra hard deps
# gst-plugins-bad is required for the valve plugin. This should move to good
# eventually at which point the dep can be dropped
RDEPEND=">=dev-libs/glib-2.25.9:2
	>=x11-libs/gtk+-2.22:2
	>=dev-libs/dbus-glib-0.51
	>=net-libs/telepathy-glib-0.11.15
	>=media-libs/libcanberra-0.4[gtk]
	>=x11-libs/libnotify-0.4.4
	>=gnome-base/gnome-keyring-2.26
	>=net-libs/gnutls-2.8.5
	>=dev-libs/folks-0.1.15
	<dev-libs/folks-0.3

	>=dev-libs/libunique-1.1.6:1
	net-libs/farsight2
	media-libs/gstreamer:0.10
	media-libs/gst-plugins-base:0.10
	media-libs/gst-plugins-bad
	media-plugins/gst-plugins-gconf:0.10
	>=net-libs/telepathy-farsight-0.0.14
	dev-libs/libxml2:2
	x11-libs/libX11
	net-voip/telepathy-connection-managers
	>=net-im/telepathy-logger-0.1.5
	<net-im/telepathy-logger-0.2.0

	eds? ( >=gnome-extra/evolution-data-server-1.2 )
	nautilus? ( >=gnome-extra/nautilus-sendto-2.31.7 )
	networkmanager? ( >=net-misc/networkmanager-0.7 )
	spell? (
		>=app-text/enchant-1.2
		>=app-text/iso-codes-0.35 )
	webkit? ( >=net-libs/webkit-gtk-1.1.15:2 )"
#	map? (
#		>=media-libs/libchamplain-0.7.1[gtk]
#		>=media-libs/clutter-gtk-0.10:0.10 )
DEPEND="${RDEPEND}
	app-text/scrollkeeper
	>=app-text/gnome-doc-utils-0.17.3
	>=dev-util/intltool-0.35.0
	>=dev-util/pkgconfig-0.16
	test? (
		sys-apps/grep
		>=dev-libs/check-0.9.4 )
	dev-libs/libxslt
"
PDEPEND=">=net-im/telepathy-mission-control-5"

pkg_setup() {
	DOCS="CONTRIBUTORS AUTHORS ChangeLog NEWS README"

	# Hard disable favourite_contacts and tpl, TpLogger is buggy.
	G2CONF="${G2CONF}
		--disable-static
		--disable-location
		--disable-map
		--disable-control-center-embedding
		--disable-Werror
		$(use_enable debug)
		$(use_with eds)
		$(use_enable nautilus nautilus-sendto)
		$(use_with networkmanager connectivity nm)
		$(use_enable spell)
		$(use_enable test coding-style-checks)
		$(use_enable webkit)"

	# Build time python tools needs python2
	python_set_active_version 2
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-libnotify-0.7.patch
	# Remove unnecessary restriction. Should get punted from configure.ac.
	sed -i -e '/libnotify/s:0.7:9999:' configure || die
	gnome2_src_prepare
	python_convert_shebangs -r 2 .
}

src_test() {
	unset DBUS_SESSION_BUS_ADDRESS
	emake check || die "emake check failed."
}

pkg_postinst() {
	gnome2_pkg_postinst
	elog "Empathy needs telepathy's connection managers to use any IM protocol."
	elog "See the USE flags on net-voip/telepathy-connection-managers"
	elog "to install them."
}
