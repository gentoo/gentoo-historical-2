# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/vte/vte-0.28.1-r300.ebuild,v 1.1 2011/06/15 02:27:55 nirbheek Exp $

EAPI="3"
GCONF_DEBUG="yes"
GNOME_TARBALL_SUFFIX="xz"
GNOME2_LA_PUNT="yes"

inherit autotools eutils gnome2

DESCRIPTION="GNOME terminal widget"
HOMEPAGE="http://git.gnome.org/browse/vte"

LICENSE="LGPL-2"
SLOT="2.90"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="debug doc glade +introspection"

PDEPEND="x11-libs/gnome-pty-helper"
RDEPEND=">=dev-libs/glib-2.26:2
	>=x11-libs/gtk+-3.0:3[introspection?]
	>=x11-libs/pango-1.22.0

	sys-libs/ncurses
	x11-libs/libX11
	x11-libs/libXft

	glade? ( >=dev-util/glade-3.9:3 )
	introspection? ( >=dev-libs/gobject-introspection-0.9.0 )"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.35
	>=dev-util/pkgconfig-0.9
	sys-devel/gettext
	doc? ( >=dev-util/gtk-doc-1.13 )"

pkg_setup() {
	# Python bindings are via gobject-introspection
	# Ex: from gi.repository import Vte
	G2CONF="${G2CONF}
		--disable-gnome-pty-helper
		--disable-deprecation
		--disable-maintainer-mode
		--disable-static
		$(use_enable debug)
		$(use_enable glade glade-catalogue)
		$(use_enable introspection)
		--with-gtk=3.0"
	DOCS="AUTHORS ChangeLog HACKING NEWS README"
}

src_prepare() {
	epatch "${FILESDIR}/${PN}-0.28.0-fix-gdk-targets.patch"

	eautoreconf

	gnome2_src_prepare
}
