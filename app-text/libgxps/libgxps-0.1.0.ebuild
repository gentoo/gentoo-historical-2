# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/libgxps/libgxps-0.1.0.ebuild,v 1.1 2011/11/03 05:10:47 tetromino Exp $

EAPI="4"
GNOME2_LA_PUNT="yes"

inherit gnome2

DESCRIPTION="Library for handling and rendering XPS documents"
HOMEPAGE="http://live.gnome.org/libgxps"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc +introspection jpeg static-libs tiff"

RDEPEND=">=app-arch/libarchive-2.8
	>=dev-libs/glib-2.24:2
	media-libs/freetype:2
	>=x11-libs/cairo-1.10
	introspection? ( >=dev-libs/gobject-introspection-0.10.1 )
	jpeg? ( virtual/jpeg )
	tiff? ( media-libs/tiff[zlib] )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	doc? (
		app-text/docbook-xml-dtd:4.1.2
		>=dev-util/gtk-doc-1.14 )"

# There is no automatic test suite, only an interactive test application
RESTRICT="test"

pkg_setup() {
	G2CONF="${G2CONF}
		--disable-test
		$(use_enable debug)
		$(use_enable introspection)
		$(use_with jpeg libjpeg)
		$(use_enable static-libs static)
		$(use_with tiff libtiff)"
	DOCS="AUTHORS ChangeLog NEWS README TODO"
}
