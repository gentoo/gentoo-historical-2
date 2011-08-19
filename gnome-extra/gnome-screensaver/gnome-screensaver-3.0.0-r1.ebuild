# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/gnome-screensaver/gnome-screensaver-3.0.0-r1.ebuild,v 1.1 2011/08/19 11:43:42 nirbheek Exp $

EAPI="4"
GCONF_DEBUG="yes"
GNOME_TARBALL_SUFFIX="bz2"

inherit eutils gnome2

DESCRIPTION="Replaces xscreensaver, integrating with the desktop."
HOMEPAGE="http://live.gnome.org/GnomeScreensaver"

LICENSE="GPL-2"
SLOT="0"
IUSE="debug doc pam"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"

RDEPEND="
	>=dev-libs/glib-2.25.6:2
	>=x11-libs/gtk+-2.99.3:3
	>=gnome-base/gnome-desktop-2.91.5:3
	>=gnome-base/gnome-menus-2.12
	>=gnome-base/gsettings-desktop-schemas-0.1.7
	>=gnome-base/libgnomekbd-0.1
	>=dev-libs/dbus-glib-0.71

	sys-apps/dbus
	x11-libs/libxklavier
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXrandr
	x11-libs/libXScrnSaver
	x11-libs/libXxf86misc
	x11-libs/libXxf86vm

	pam? ( virtual/pam )
"
DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.9
	>=dev-util/intltool-0.35
	sys-devel/gettext
	doc? (
		app-text/xmlto
		~app-text/docbook-xml-dtd-4.1.2
		~app-text/docbook-xml-dtd-4.4 )
	x11-proto/xextproto
	x11-proto/randrproto
	x11-proto/scrnsaverproto
	x11-proto/xf86miscproto
"

pkg_setup() {
	DOCS="AUTHORS ChangeLog HACKING NEWS README"
	G2CONF="${G2CONF}
		$(use_enable doc docbook-docs)
		$(use_enable pam locking)
		--with-mit-ext
		--with-pam-prefix=/etc
		--with-xf86gamma-ext
		--with-kbd-layout-indicator
		--disable-schemas-compile"
	# xscreensaver and custom screensaver capability removed
	# poke and inhibit commands were also removed, bug 579430
}

src_prepare() {
	# Upstream patch to fix crash in user switcher; will be in next release
	epatch "${FILESDIR}/${P}-user-switcher-crash.patch"

	# Upstream patches to fix timers and update the clock properly; will be
	# in next release
	epatch "${FILESDIR}/${P}-watchdog-add_seconds.patch"
	epatch "${FILESDIR}/${P}-clock-skew.patch"

	gnome2_src_prepare
}
