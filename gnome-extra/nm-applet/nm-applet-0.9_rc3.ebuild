# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/nm-applet/nm-applet-0.9_rc3.ebuild,v 1.3 2011/08/16 10:16:20 nirbheek Exp $

EAPI="4"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"
GNOME_TARBALL_SUFFIX="bz2"
GNOME_ORG_MODULE="network-manager-applet"
GNOME_ORG_PVP="0.8"
REAL_PV="0.8.9997"

inherit gnome2

DESCRIPTION="GNOME applet for NetworkManager"
HOMEPAGE="http://projects.gnome.org/NetworkManager/"
# Replace our fake _rc version with the actual version
SRC_URI="${SRC_URI//${PV}/${REAL_PV}}"

LICENSE="GPL-2"
SLOT="0"
IUSE="bluetooth"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND=">=dev-libs/glib-2.16:2
	>=dev-libs/dbus-glib-0.88
	>=gnome-base/gconf-2.20:2
	>=gnome-base/gnome-keyring-2.20
	>=sys-apps/dbus-1.4.1
	>=sys-auth/polkit-0.96-r1
	>=x11-libs/gtk+-2.91.4:3
	>=x11-libs/libnotify-0.7.0

	>=net-misc/networkmanager-${PV}
	net-misc/mobile-broadband-provider-info

	bluetooth? ( >=net-wireless/gnome-bluetooth-2.27.6 )"

DEPEND="${RDEPEND}
	dev-util/pkgconfig
	>=dev-util/intltool-0.40"

# Replace our fake _rc version with the actual version
S="${WORKDIR}/${GNOME_ORG_MODULE}-${REAL_PV}"

pkg_setup() {
	DOCS="AUTHORS ChangeLog NEWS README"
	G2CONF="${G2CONF}
		--with-gtkver=3
		--disable-more-warnings
		--disable-static
		--localstatedir=/var
		$(use_with bluetooth)"
}
