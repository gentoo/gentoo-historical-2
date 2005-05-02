# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/totem/totem-1.0.2.ebuild,v 1.2 2005/05/02 20:24:01 gustavoz Exp $

inherit gnome2 eutils

DESCRIPTION="Media player for GNOME"
HOMEPAGE="http://gnome.org/projects/totem/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~sparc ~x86"
IUSE="gnome xine lirc mad mpeg ogg vorbis a52 flac theora mad dvd debug win32codecs"

RDEPEND=">=dev-libs/glib-2.6.3
	>=x11-libs/gtk+-2.6
	>=gnome-base/gnome-vfs-2.2
	>=gnome-base/libglade-2
	>=gnome-extra/nautilus-cd-burner-2.9
	>=gnome-base/gnome-desktop-2.2
	>=gnome-base/libgnomeui-2.4
	gnome? ( >=gnome-base/nautilus-2.10 )
	lirc? ( app-misc/lirc )
	!sparc? ( xine? ( >=media-libs/xine-lib-1
		>=gnome-base/gconf-2 ) )
	!xine? ( >=media-libs/gstreamer-0.8.9-r3
		>=media-libs/gst-plugins-0.8.8
		>=media-plugins/gst-plugins-gnomevfs-0.8.8
		>=media-plugins/gst-plugins-xvideo-0.8.8
		>=media-plugins/gst-plugins-pango-0.8.8
		>=media-plugins/gst-plugins-ffmpeg-0.8.3
		mad? ( >=media-plugins/gst-plugins-mad-0.8.8 )
		mpeg? ( >=media-plugins/gst-plugins-mpeg2dec-0.8.8 )
		ogg? ( >=media-plugins/gst-plugins-ogg-0.8.8 )
		vorbis? ( >=media-plugins/gst-plugins-ogg-0.8.8
			>=media-plugins/gst-plugins-vorbis-0.8.8 )
		a52? ( >=media-plugins/gst-plugins-a52dec-0.8.8 )
		flac? ( >=media-plugins/gst-plugins-flac-0.8.8 )
		theora? ( >=media-plugins/gst-plugins-ogg-0.8.8
		        >=media-plugins/gst-plugins-theora-0.8.8 )
		mad? ( >=media-plugins/gst-plugins-mad-0.8.8 )
		dvd? ( >=media-plugins/gst-plugins-a52dec-0.8.8
			>=media-plugins/gst-plugins-dvdread-0.8.8
			>=media-plugins/gst-plugins-mpeg2dec-0.8.8 )
		win32codecs? ( >=media-plugins/gst-plugins-pitfdll-0.8.1 )
		)
	!gnome-extra/nautilus-media"

DEPEND="${RDEPEND}
	app-text/scrollkeeper
	>=dev-util/intltool-0.29
	>=dev-util/pkgconfig-0.12.0"

DOCS="AUTHORS ChangeLog COPYING README INSTALL NEWS TODO"

# gstreamer is default backend
use xine || G2CONF="${G2CONF} --enable-gstreamer"

# gtk only support broken
#use gnome \
#	&& G2CONF="${G2CONF} --disable-gtk" \
#	|| G2CONF="${G2CONF} --enable-gtk"

G2CONF="${G2CONF} \
	$(use_enable lirc) \
	$(use_enable debug) \
	$(use_enable gnome nautilus) \
	--disable-gtk \
	--disable-mozilla"

src_unpack() {

	unpack ${A}

	cd ${S}
	# use the omf_fix for scrollkeeper sandbox
	# violations, see bug #48800 <obz@gentoo.org>
	gnome2_omf_fix

}

pkg_postinst() {

	gnome2_pkg_postinst

	einfo "Note that the default totem backend has switched to gstreamer."
	einfo "DVD menus will only work with the xine backend."

}

USE_DESTDIR="1"
