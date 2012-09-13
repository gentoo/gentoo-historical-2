# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/gnome-bluetooth/gnome-bluetooth-3.4.2-r1.ebuild,v 1.2 2012/09/13 10:43:51 tetromino Exp $

EAPI="4"
GCONF_DEBUG="yes"
GNOME2_LA_PUNT="yes"

inherit eutils gnome2 multilib toolchain-funcs

DESCRIPTION="Fork of bluez-gnome focused on integration with GNOME"
HOMEPAGE="http://live.gnome.org/GnomeBluetooth"

LICENSE="GPL-2 LGPL-2.1"
SLOT="2"
IUSE="doc +introspection sendto"
KEYWORDS="~amd64 ~x86"

COMMON_DEPEND=">=dev-libs/glib-2.29.90:2
	>=x11-libs/gtk+-2.91.3:3[introspection?]
	>=x11-libs/libnotify-0.7.0

	introspection? ( >=dev-libs/gobject-introspection-0.9.5 )
	sendto? ( >=gnome-extra/nautilus-sendto-2.91 )
"
RDEPEND="${COMMON_DEPEND}
	>=net-wireless/bluez-4.34
	app-mobilephone/obexd
	sys-fs/udev
	x11-themes/gnome-icon-theme-symbolic"
DEPEND="${COMMON_DEPEND}
	!net-wireless/bluez-gnome
	app-text/docbook-xml-dtd:4.1.2
	app-text/gnome-doc-utils
	app-text/scrollkeeper
	dev-libs/libxml2
	>=dev-util/intltool-0.40.0
	dev-util/gdbus-codegen
	>=sys-devel/gettext-0.17
	virtual/pkgconfig
	x11-libs/libX11
	x11-libs/libXi
	x11-proto/xproto
	doc? ( >=dev-util/gtk-doc-1.9 )"
# eautoreconf needs:
#	gnome-base/gnome-common
#	dev-util/gtk-doc-am

pkg_setup() {
	# FIXME: Add geoclue support
	G2CONF="${G2CONF}
		$(use_enable introspection)
		$(use_enable sendto nautilus-sendto)
		--enable-documentation
		--disable-maintainer-mode
		--disable-desktop-update
		--disable-icon-update
		--disable-schemas-compile
		--disable-static"
	DOCS="AUTHORS README NEWS ChangeLog"

	enewgroup plugdev
}

src_install() {
	gnome2_src_install

	local udevdir="$($(tc-getPKG_CONFIG) --variable=udevdir udev)"
	insinto "${udevdir}"/rules.d
	doins "${FILESDIR}"/80-rfkill.rules
}

pkg_postinst() {
	gnome2_pkg_postinst
	# Notify about old libraries that might still be around
	preserve_old_lib_notify /usr/$(get_libdir)/libgnome-bluetooth.so.7

	elog "Don't forget to add yourself to the plugdev group "
	elog "if you want to be able to control bluetooth transmitter."
}
