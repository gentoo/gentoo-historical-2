# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/soundconverter/soundconverter-0.8.3.ebuild,v 1.1 2006/01/25 14:23:21 hanno Exp $

inherit eutils

DESCRIPTION="A simple sound converter application for the GNOME environment."
HOMEPAGE="http://soundconverter.berlios.de/"
SRC_URI="http://download.berlios.de/soundconverter/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="mp3 vorbis flac"

RDEPEND="virtual/python
	>=x11-libs/gtk+-2
	>=dev-python/pygtk-2.0.0
	>=dev-python/gnome-python-2.0
	gnome-base/libglade
	gnome-base/gconf
	gnome-base/gnome-vfs
	=media-libs/gstreamer-0.8*
	=dev-python/gst-python-0.8*
	vorbis? ( =media-plugins/gst-plugins-vorbis-0.8* )
	flac? ( =media-plugins/gst-plugins-flac-0.8* )
	mp3? ( =media-plugins/gst-plugins-lame-0.8* )"

src_unpack() {
	unpack ${A}
	epatch ${FILESDIR}/${P}-makefile-fix.diff
}

src_compile() {
	einfo "No compilation necessary"
}

src_install () {
	make prefix=/usr DESTDIR=${D} install || die
}
