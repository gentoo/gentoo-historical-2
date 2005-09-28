# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/bmpx/bmpx-0.11.4.ebuild,v 1.1 2005/09/28 09:35:43 azarah Exp $

inherit gnome2 eutils

MY_P=${P/_p/-}
S="${WORKDIR}/${MY_P}"
DESCRIPTION="Next generation Beep Media Player"
HOMEPAGE="http://www.sosdg.org/~larne/w/BMPx"
SRC_URI="http://download.berlios.de/${PN}/${MY_P}.tar.gz
	http://beepmp.sf.net/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="xine hal mad ogg vorbis a52 flac theora"

RDEPEND=">=dev-libs/glib-2.8.0
	>=x11-libs/gtk+-2.8.0
	>=gnome-base/libglade-2.5.1
	>=x11-libs/pango-1.10.0
	>=dev-libs/libxml2-2.6.18
	>=x11-libs/cairo-1.0.0
	>=media-libs/taglib-1.4
	dbus? ( >=sys-apps/dbus-0.3.5 )
	virtual/fam
	>=media-libs/xine-lib-1.0.1"
# gstreamer support is on hold until gstreamer 0.9
#	xine? ( >=media-libs/xine-lib-1.0.1 )
#	!xine? ( >=media-libs/gstreamer-0.8.9-r3
#		>=media-libs/gst-plugins-0.8.8
#		>=media-plugins/gst-plugins-pango-0.8.8
#		mad? ( >=media-plugins/gst-plugins-mad-0.8.8 )
#		ogg? ( >=media-plugins/gst-plugins-ogg-0.8.8 )
#		vorbis? ( >=media-plugins/gst-plugins-ogg-0.8.8
#			>=media-plugins/gst-plugins-vorbis-0.8.8 )
#		a52? ( >=media-plugins/gst-plugins-a52dec-0.8.8 )
#		flac? ( >=media-plugins/gst-plugins-flac-0.8.8 )
#		theora? ( >=media-plugins/gst-plugins-ogg-0.8.8
#		        >=media-plugins/gst-plugins-theora-0.8.8 )
#		)"

DEPEND="${RDEPEND}
	>=dev-util/intltool-0.29
	>=dev-util/pkgconfig-0.12.0"

DOCS="AUTHORS COPYING ChangeLog NEWS README"

# gstreamer is default backend
G2CONF="${G2CONF} $(use_enable hal)"
#useq xine || G2CONF="${G2CONF} --enable-gst"

USE_DESTDIR="1"

