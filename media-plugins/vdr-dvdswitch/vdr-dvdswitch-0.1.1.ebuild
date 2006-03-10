# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-dvdswitch/vdr-dvdswitch-0.1.1.ebuild,v 1.1 2006/03/10 21:12:58 hd_brummy Exp $

inherit vdr-plugin

DESCRIPTION="vdr plugin to play dvds and dvd file structures"
HOMEPAGE="http://vdrportal.de/board/thread.php?threadid=39984"
SRC_URI="http://download.schmidtie.de/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"

DEPEND=">=media-video/vdr-1.3.21"
RDEPEND="media-plugins/vdr-dvd
		>=media-tv/vdr-dvd-scripts-0.0.1-r2"

DEFAULT_IMAGE_DIR="/var/vdr/video/dvd-images"

src_unpack() {
	vdr-plugin_src_unpack

	# patching default image-dir to /var/vdr/video/dvd-images
	sed -e "s:/video/dvd:${DEFAULT_IMAGE_DIR}:" -i setup.c
}
