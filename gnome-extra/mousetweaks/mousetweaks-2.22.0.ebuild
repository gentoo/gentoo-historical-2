# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/mousetweaks/mousetweaks-2.22.0.ebuild,v 1.1 2008/03/26 22:45:13 eva Exp $

inherit gnome2 autotools

DESCRIPTION="Mouse accessibility enhancements for the GNOME desktop"
HOMEPAGE="http://live.gnome.org/Mousetweaks/Home"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2.10
	>=gnome-base/gconf-2
	>=gnome-base/libglade-2
	>=gnome-base/gnome-panel-2
	>=dev-libs/dbus-glib-0.72
	gnome-extra/at-spi
	>=gnome-base/libgnome-2
	>=gnome-base/libgnomeui-2
	x11-libs/libXfixes"
DEPEND="${RDEPEND}"

src_unpack() {
	gnome2_src_unpack

	# Fix -Wl,--as-needed failure, FIXME: report upstream
	sed -i "s/_LDFLAGS/_LDADD/g" src/Makefile.am
	eautoreconf
}
