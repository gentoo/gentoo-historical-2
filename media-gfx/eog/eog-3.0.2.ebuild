# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/eog/eog-3.0.2.ebuild,v 1.1 2011/08/16 19:50:38 nirbheek Exp $

EAPI="3"
GCONF_DEBUG="yes"
GNOME2_LA_PUNT="yes"

inherit gnome2

DESCRIPTION="The Eye of GNOME image viewer"
HOMEPAGE="http://www.gnome.org/projects/eog/"

LICENSE="GPL-2"
SLOT="1"
IUSE="dbus doc +exif +introspection +jpeg lcms +svg tiff xmp"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"

RDEPEND=">=x11-libs/gtk+-3.0.2:3[introspection]
	>=dev-libs/glib-2.25.15:2
	>=dev-libs/libxml2-2:2
	>=dev-libs/libpeas-0.7.4[gtk]
	>=gnome-base/gnome-desktop-2.91.2:3
	>=gnome-base/gsettings-desktop-schemas-2.91.92
	>=x11-themes/gnome-icon-theme-2.19.1
	>=x11-misc/shared-mime-info-0.20

	x11-libs/gdk-pixbuf:2[jpeg?,tiff?]
	x11-libs/libX11

	dbus? ( >=dev-libs/dbus-glib-0.71 )
	exif? (
		>=media-libs/libexif-0.6.14
		virtual/jpeg:0 )
	introspection? ( >=dev-libs/gobject-introspection-0.9.3 )
	jpeg? ( virtual/jpeg:0 )
	lcms? ( media-libs/lcms:0 )
	svg? ( >=gnome-base/librsvg-2.26:2 )
	xmp? ( media-libs/exempi:2 )"

DEPEND="${RDEPEND}
	app-text/gnome-doc-utils
	sys-devel/gettext
	>=dev-util/intltool-0.40
	>=dev-util/pkgconfig-0.17
	doc? ( >=dev-util/gtk-doc-1.10 )"

pkg_setup() {
	G2CONF="${G2CONF}
		$(use_enable introspection)
		$(use_with jpeg libjpeg)
		$(use_with exif libexif)
		$(use_with dbus)
		$(use_with lcms cms)
		$(use_with xmp)
		$(use_with svg librsvg)
		--disable-scrollkeeper
		--disable-schemas-compile"
	DOCS="AUTHORS ChangeLog HACKING MAINTAINERS NEWS README THANKS TODO"
}
