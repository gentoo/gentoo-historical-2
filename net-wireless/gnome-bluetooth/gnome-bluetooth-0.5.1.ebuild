# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/gnome-bluetooth/gnome-bluetooth-0.5.1.ebuild,v 1.1 2004/06/27 03:59:44 liquidx Exp $

inherit python gnome2 eutils

DESCRIPTION="Gnome2 Bluetooth integration suite."
HOMEPAGE="http://usefulinc.com/software/gnome-bluetooth/"
SRC_URI="http://downloads.usefulinc.com/gnome-bluetooth/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~sparc"
IUSE=""

RDEPEND=">=gnome-base/libgnomeui-2
	>=gnome-base/gnome-vfs-2.1.3
	>=x11-libs/gtk+-2
	>=gnome-base/librsvg-2
	>=gnome-base/libglade-2
	>=gnome-base/libgnome-2
	>=gnome-base/libbonobo-2
	>=gnome-base/libbonoboui-2
	>=gnome-base/gconf-2
	>=gnome-base/ORBit2-2
	>=dev-libs/glib-2
	>=dev-libs/openobex-1.0
	>=net-wireless/bluez-libs-2.7
	>=net-wireless/libbtctl-0.4.1
	>=dev-python/pygtk-2.0"

DEPEND="${RDEPEND}
	dev-util/intltool
	dev-util/pkgconfig"

DOCS="README NEWS AUTHORS COPYING ChangeLog"
MAKEOPTS="${MAKEOPTS} -j1"
PYTHON_MODNAME="gnomebt"

pkg_postinst() {
	python_pkg_postinst
	gnome_pkg_postinst
}

pkg_postrm() {
	python_pkg_postrm
	gnome_pkg_postrm
}