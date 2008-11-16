# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/music-applet/music-applet-2.4.2.ebuild,v 1.2 2008/11/16 19:01:40 eva Exp $

inherit gnome2 python eutils

DESCRIPTION="GNOME applet to control various music players"
HOMEPAGE="http://www.kuliniewicz.org/music-applet"
SRC_URI="http://www.kuliniewicz.org/${PN}/downloads/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="libnotify"

# This ebuild is far from perfect, it does a lot of automagic detection

RDEPEND=">=x11-libs/gtk+-2.6
	>=x11-libs/pango-1.6
	>=gnome-base/libgnomeui-2
	>=gnome-base/gnome-panel-2
	>=dev-python/gnome-python-desktop-2.14
	>=dev-python/dbus-python-0.80
	>=dev-libs/dbus-glib-0.71
	>=dev-python/pygtk-2.6
	libnotify? ( dev-python/notify-python )"
DEPEND="dev-util/pkgconfig
	dev-util/intltool"

src_unpack() {
	gnome2_src_unpack

	# disable pyc compiling
	mv py-compile py-compile.orig
	ln -s $(type -P true) py-compile
}

pkg_postinst() {
	gnome2_pkg_postinst
	python_version
	python_mod_optimize /usr/$(get_libdir)/python${PYVER}/site-packages/musicapplet
}

pkg_postrm() {
	gnome2_pkg_postrm
	python_mod_cleanup /usr/$(get_libdir)/python*/site-packages/musicapplet
}
