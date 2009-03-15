# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/mousetweaks/mousetweaks-2.24.3.ebuild,v 1.5 2009/03/15 22:33:48 maekke Exp $

inherit gnome2

DESCRIPTION="Mouse accessibility enhancements for the GNOME desktop"
HOMEPAGE="http://live.gnome.org/Mousetweaks/Home"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ~ia64 ppc ppc64 ~sparc x86"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2.13.1
	>=gnome-base/libglade-2.4
	>=gnome-base/gconf-2.16
	>=dev-libs/dbus-glib-0.72
	>=gnome-base/gnome-panel-2
	gnome-extra/at-spi

	x11-libs/libXtst
	x11-libs/libXfixes
	x11-libs/libXcursor"
DEPEND="${RDEPEND}
	  gnome-base/gnome-common
	>=dev-util/intltool-0.40
	>=dev-util/pkgconfig-0.17"
