# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-dxr3/vdr-dxr3-0.2.7.ebuild,v 1.5 2008/04/21 17:50:46 zzam Exp $

inherit vdr-plugin

DESCRIPTION="VDR plugin: Use a dxr3 or hw+ card as output device"
HOMEPAGE="http://sourceforge.net/projects/dxr3plugin/"
SRC_URI="mirror://sourceforge/dxr3plugin/${P}.tgz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 x86"
IUSE=""

DEPEND="media-video/em8300-libraries
		>=media-video/vdr-1.3.42
		media-video/ffmpeg"

PATCHES=("${FILESDIR}/${P}-ffmpeg.patch")

src_unpack() {
	vdr-plugin_src_unpack

	cd "${S}"
	sed -i Makefile -e 's:^FFMDIR =.*$:FFMDIR=/usr/include/ffmpeg:'
}
