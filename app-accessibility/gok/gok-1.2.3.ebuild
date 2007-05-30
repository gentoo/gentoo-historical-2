# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-accessibility/gok/gok-1.2.3.ebuild,v 1.4 2007/05/30 00:14:09 ticho Exp $

inherit virtualx gnome2

DESCRIPTION="Gnome Onscreen Keyboard"
HOMEPAGE="http://www.gok.ca/"

LICENSE="LGPL-2"
SLOT="1"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 sparc x86"
IUSE="doc usb"

RDEPEND=">=dev-libs/glib-2.11
	>=gnome-base/libgnomeui-2
	>=gnome-extra/at-spi-1.5.2
	>=gnome-base/libbonobo-2.5.1
	>=dev-libs/atk-1.3
	>=x11-libs/gtk+-2.3.1
	gnome-base/gail
	>=x11-libs/libwnck-2.13.5
	app-accessibility/gnome-speech
	media-sound/esound
	>=gnome-base/libglade-2
	>=gnome-base/gconf-2
	>=gnome-base/orbit-2
	usb? ( >=dev-libs/libusb-0.1.11 )

	x11-libs/libXi
	x11-libs/libX11
	x11-libs/libSM
	x11-libs/libICE"

DEPEND="${RDEPEND}
	>=dev-util/intltool-0.35
	>=dev-util/pkgconfig-0.9
	app-text/scrollkeeper
	doc? ( >=dev-util/gtk-doc-1 )

	x11-libs/libXt
	x11-proto/inputproto
	x11-proto/kbproto
	x11-proto/xproto"

DOCS="AUTHORS ChangeLog NEWS README"

# So it doesn't break when building kbd files
MAKEOPTS="${MAKEOPTS} -j1"


pkg_setup() {
	# Don't use 'use_enable' for now, because of a bug in gok's configure.in.
	use usb && G2CONF="--enable-libusb-input"
}

src_test() {
	# Remove missing file from the Makefile to fix tests (bug #140265), and POTFILES.in
	sed -i -e '/char-frequency.xml.in/d' ${S}/po/Makefile
	sed -i -e '/char-frequency.xml.in/d' ${S}/po/POTFILES.in
	addwrite "/root/.gnome2_private"
	Xmake check || die
}
