# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/vte/vte-0.28.2-r201.ebuild,v 1.2 2011/11/16 20:54:48 tetromino Exp $

EAPI="4"
GCONF_DEBUG="yes"
GNOME2_LA_PUNT="yes"
PYTHON_DEPEND="python? 2:2.4"

inherit eutils gnome2 python

DESCRIPTION="GNOME terminal widget"
HOMEPAGE="http://git.gnome.org/browse/vte"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="debug doc glade +introspection python"

PDEPEND="x11-libs/gnome-pty-helper"
RDEPEND=">=dev-libs/glib-2.26:2
	>=x11-libs/gtk+-2.20:2[introspection?]
	>=x11-libs/pango-1.22.0

	sys-libs/ncurses
	x11-libs/libX11
	x11-libs/libXft

	glade? ( dev-util/glade:3 )
	introspection? ( >=dev-libs/gobject-introspection-0.9.0 )
	python? ( >=dev-python/pygtk-2.4:2 )"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.35
	>=dev-util/pkgconfig-0.9
	sys-devel/gettext
	doc? ( >=dev-util/gtk-doc-1.13 )"

pkg_setup() {
	G2CONF="${G2CONF}
		--disable-gnome-pty-helper
		--disable-deprecation
		--disable-maintainer-mode
		--disable-static
		$(use_enable debug)
		$(use_enable glade glade-catalogue)
		$(use_enable introspection)
		$(use_enable python)
		--with-gtk=2.0"
	DOCS="AUTHORS ChangeLog HACKING NEWS README"
	if use python; then
		python_set_active_version 2
		python_pkg_setup
	fi
}

src_prepare() {
	# https://bugzilla.gnome.org/show_bug.cgi?id=663779
	epatch "${FILESDIR}/${PN}-0.30.1-alt-meta.patch"

	gnome2_src_prepare
}

src_install() {
	gnome2_src_install
	use python && python_clean_installation_image
}
