# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/rhythmbox/rhythmbox-0.8.0-r1.ebuild,v 1.4 2004/09/03 14:03:03 pvdabeel Exp $

inherit gnome2 flag-o-matic

DESCRIPTION="Music management and playback software for GNOME"
HOMEPAGE="http://www.rhythmbox.org/"
LICENSE="GPL-2"

KEYWORDS="~x86 ppc ~amd64"
IUSE="oggvorbis xine flac faad mad pda"
SLOT="0"

RDEPEND=">=x11-libs/gtk+-2.2
	>=gnome-base/libgnomeui-2
	>=gnome-base/libglade-2
	>=gnome-base/gnome-vfs-2
	>=gnome-base/libbonobo-2
	!xine? ( >=media-libs/gst-plugins-0.8.0
		 >=media-plugins/gst-plugins-gnomevfs-0.8.0
		 oggvorbis? ( >=media-plugins/gst-plugins-vorbis-0.8.0
		              >=media-plugins/gst-plugins-ogg-0.8.0 )
		 mad? ( >=media-plugins/gst-plugins-mad-0.8.0 )
		 flac? ( >=gst-plugins-flac-0.8.0 ) )
	xine? ( faad? ( >=media-libs/faad2-2.0_rc3 )
		flac? ( >=media-libs/flac-1
			>=media-libs/libid3tag-0.15.0b )
		oggvorbis? ( >=media-libs/libvorbis-1 )
		mad? ( >=media-libs/libid3tag-0.15.0b )
		>=media-libs/xine-lib-1_rc3 )"

# REMIND : should we really force flac ?
# I want to drop flac deps when rb get proper gst only/non monkey-media
# flac support. Made it a local USE flag for now
# <foser@gentoo.org> 06 Oct 2003

DEPEND="${RDEPEND}
	dev-util/pkgconfig
	app-text/scrollkeeper"

MAKEOPTS="${MAKEOPTS} -j1"

use xine &&\
	G2CONF="${G2CONF} --with-player=xine --with-metadata=monkeymedia" ||\
	G2CONF="${G2CONF} --with-player=gstreamer --with-metadata=gstreamer"

G2CONF="${G2CONF} \
	$(use_enable oggvorbis vorbis) \
	$(use_enable flac) \
	$(use_enable mad mp3) \
	$(use_enable faad mp4) \
	$(use_enable pda ipod) \
	--enable-mmkeys \
	--enable-audiocd \
	--disable-dashboard \
	--disable-schemas-install"

DOCS="AUTHORS COPYING ChangeLog DOCUMENTERS INSTALL INTERNALS \
	  MAINTAINERS NEWS README README.iPod THANKS TODO"

export GST_INSPECT=/bin/true

src_unpack( ) {
	unpack ${A}

	cd ${S}
	# sandbox errors work around
	gnome2_omf_fix ${S}/help/C/Makefile.in
}
