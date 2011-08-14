# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/nm-applet/nm-applet-0.8.4.ebuild,v 1.3 2011/08/14 09:04:07 nirbheek Exp $

EAPI="3"
GNOME_ORG_MODULE="network-manager-applet"

inherit gnome2

DESCRIPTION="Gnome applet for NetworkManager."
HOMEPAGE="http://projects.gnome.org/NetworkManager/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="bluetooth"

RDEPEND=">=dev-libs/glib-2.16:2
	>=dev-libs/dbus-glib-0.88
	>=sys-apps/dbus-1.4.1
	>=x11-libs/gtk+-2.18:2
	>=gnome-base/gconf-2.20:2
	>=x11-libs/libnotify-0.4.3
	>=gnome-base/gnome-keyring-2.20
	>=sys-auth/polkit-0.96-r1

	>=net-misc/networkmanager-${PV}
	net-misc/mobile-broadband-provider-info

	bluetooth? ( >=net-wireless/gnome-bluetooth-2.27.6 )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	>=dev-util/intltool-0.40"

pkg_setup () {
	G2CONF="${G2CONF}
		--disable-more-warnings
		--localstatedir=/var
		$(use_with bluetooth)"

	DOCS="AUTHORS ChangeLog NEWS README"
}
