# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/sound-juicer/sound-juicer-2.16.2.ebuild,v 1.3 2006/12/12 16:53:04 wolf31o2 Exp $

inherit gnome2

DESCRIPTION="CD ripper for GNOME 2"
HOMEPAGE="http://www.burtonini.com/blog/computers/sound-juicer/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc x86"
IUSE="flac ogg"

RDEPEND=">=dev-libs/glib-2
	>=gnome-extra/nautilus-cd-burner-2.15.3
	>=x11-libs/gtk+-2.8
	>=gnome-base/libglade-2
	>=gnome-base/gconf-2
	>=gnome-base/libgnomeui-2.13
	>=gnome-base/gnome-vfs-2.9
	>=media-libs/gstreamer-0.10.3
	>=gnome-extra/gnome-media-2.11.91
	>=media-libs/musicbrainz-2.1
	>=dev-libs/libcdio-0.70
	media-libs/taglib
	>=media-libs/gst-plugins-base-0.10
	>=media-plugins/gst-plugins-gconf-0.10
	>=media-plugins/gst-plugins-gnomevfs-0.10
	>=media-plugins/gst-plugins-cdparanoia-0.10
	ogg? ( >=media-plugins/gst-plugins-ogg-0.10 )
	flac? ( >=media-plugins/gst-plugins-flac-0.10 )"

DEPEND="${RDEPEND}
	app-text/gnome-doc-utils
	>=dev-util/intltool-0.35
	>=app-text/scrollkeeper-0.3.5
	>=dev-util/pkgconfig-0.9"

DOCS="AUTHORS ChangeLog NEWS README TODO"

# needed to get around some sandboxing checks
export GST_INSPECT=/bin/true

pkg_setup() {
	G2CONF="${G2CONF} --disable-scrollkeeper"
}

