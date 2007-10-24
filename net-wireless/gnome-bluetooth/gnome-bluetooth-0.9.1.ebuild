# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/gnome-bluetooth/gnome-bluetooth-0.9.1.ebuild,v 1.2 2007/10/24 13:48:40 eva Exp $

inherit distutils gnome2 eutils multilib autotools

DESCRIPTION="Gnome2 Bluetooth integration suite"
HOMEPAGE="http://live.gnome.org/GnomeBluetooth"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

RDEPEND=">=gnome-base/libgnomeui-2
	>=x11-libs/gtk+-2.10
	>=gnome-base/librsvg-2
	>=gnome-base/libglade-2
	>=gnome-base/libgnome-2
	>=gnome-base/libbonobo-2
	>=gnome-base/libbonoboui-2
	>=gnome-base/gconf-2
	>=gnome-base/orbit-2
	>=dev-util/gob-2
	>=dev-libs/openobex-1.2
	>=net-wireless/bluez-libs-2.25
	>=net-wireless/libbtctl-0.8.1
	>=dev-python/pygtk-2.6
	>=dev-python/gnome-python-2.6"

DEPEND="${RDEPEND}
	>=dev-util/intltool-0.35
	dev-util/pkgconfig"

DOCS="README NEWS AUTHORS COPYING ChangeLog"
MAKEOPTS="${MAKEOPTS} -j1"
PYTHON_MODNAME="gnomebt"

src_unpack() {
	unpack ${A}
	cd "${S}"

	sed -i -e 's:${libdir:/${platlibdir:' acinclude.m4 || die "sed failed"
	eautoreconf
}

src_compile() {
	platlibdir=$(get_libdir) gnome2_src_compile
}

pkg_postinst() {
	distutils_pkg_postinst
	gnome2_pkg_postinst
}

pkg_postrm() {
	distutils_pkg_postrm
	gnome2_pkg_postrm
}
