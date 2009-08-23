# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/cheese/cheese-2.24.3.ebuild,v 1.4 2009/08/23 02:01:48 eva Exp $

GCONF_DEBUG="no"

inherit gnome2 eutils

DESCRIPTION="A cheesy program to take pictures and videos from your webcam"
HOMEPAGE="http://www.gnome.org/projects/cheese/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="v4l"

RDEPEND=">=dev-libs/dbus-glib-0.7
	>=dev-libs/glib-2.16.0
	>=gnome-base/gconf-2.16.0
	>=gnome-base/gnome-vfs-2.18
	>=gnome-base/libgnomeui-2.14.0
	>=gnome-base/librsvg-2.18.0
	>=gnome-extra/evolution-data-server-1.12
	>=media-libs/gstreamer-0.10.16
	>=media-libs/gst-plugins-base-0.10.16
	>=media-plugins/gst-plugins-gconf-0.10
	>=media-plugins/gst-plugins-ogg-0.10.16
	>=media-plugins/gst-plugins-pango-0.10.16
	>=media-plugins/gst-plugins-theora-0.10.16
	>=media-plugins/gst-plugins-v4l2-0.10
	>=media-plugins/gst-plugins-vorbis-0.10.16
	>=sys-apps/dbus-1
	>=sys-apps/hal-0.5.9
	>=x11-libs/cairo-1.4.0
	>=x11-libs/gtk+-2.12
	>=x11-libs/pango-1.18.0
	v4l? ( >=media-plugins/gst-plugins-v4l-0.10 )"

DEPEND="${RDEPEND}
	>=dev-util/intltool-0.40
	dev-util/pkgconfig
	app-text/scrollkeeper
	app-text/gnome-doc-utils
	x11-proto/xf86vidmodeproto
	~app-text/docbook-xml-dtd-4.3"

DOCS="AUTHORS ChangeLog NEWS README"

pkg_setup() {
	G2CONF="${G2CONF} --disable-scrollkeeper --disable-hildon"
}
