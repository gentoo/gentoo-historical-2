# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/muine/muine-0.6.3.ebuild,v 1.1 2004/06/21 00:55:28 latexer Exp $

inherit gnome2 mono

DESCRIPTION="A music player for GNOME"
HOMEPAGE="http://muine.gooeylinux.org/"
SRC_URI="${HOMEPAGE}${P}.tar.gz"
LICENSE="GPL-2"
IUSE="xine mad oggvorbis flac"
SLOT="0"
KEYWORDS="~x86"

RDEPEND=">=dev-dotnet/mono-0.96
	>=x11-libs/gtk-sharp-0.98
	xine? ( >=media-libs/xine-lib-1_rc4 )
	!xine? (
		>=media-libs/gstreamer-0.8.0
		>=media-libs/gst-plugins-0.8.0
		mad? ( >=media-plugins/gst-plugins-mad-0.8.0 )
		oggvorbis? ( >=media-plugins/gst-plugins-vorbis-0.8.0 )
		flac? ( >=media-plugins/gst-plugins-flac-0.8.0 )
	)
	>=media-libs/libid3tag-0.15.0b
	>=media-libs/libvorbis-1.0
	sys-libs/gdbm
	>=gnome-base/gconf-2.0.0
	>=gnome-base/gnome-vfs-2.0.0
	>=x11-libs/gtk+-2.0.0
	media-libs/flac"

DEPEND="${RDEPEND}
	dev-util/pkgconfig
	app-text/scrollkeeper"

use xine && \
	G2CONF="${G2CONF} --enable-gstreamer=no" || \
	G2CONF="${G2CONF} --enable-gstreamer=yes"

DOCS="AUTHORS COPYING ChangeLog INSTALL \
	  MAINTAINERS NEWS README TODO"
