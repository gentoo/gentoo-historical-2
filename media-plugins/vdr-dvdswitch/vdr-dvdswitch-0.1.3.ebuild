# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-dvdswitch/vdr-dvdswitch-0.1.3.ebuild,v 1.3 2007/10/04 12:09:32 zzam Exp $

inherit vdr-plugin

DESCRIPTION="vdr plugin to play dvds and dvd file structures"
HOMEPAGE="http://vdrportal.de/board/thread.php?threadid=39984"
SRC_URI="http://download.schmidtie.de/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE=""

DEPEND=">=media-video/vdr-1.3.21"
RDEPEND="media-plugins/vdr-dvd
		|| ( >=media-tv/gentoo-vdr-scripts-0.4.1
			>=media-tv/vdr-dvd-scripts-0.0.1-r5 )"

DEFAULT_IMAGE_DIR="/var/vdr/video/dvd-images"

src_unpack() {
	vdr-plugin_src_unpack

	# patching default image-dir to /var/vdr/video/dvd-images
	sed -e "s:/video/dvd:${DEFAULT_IMAGE_DIR}:" -i setup.c
}
