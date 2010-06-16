# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-osdpip/vdr-osdpip-0.0.10.ebuild,v 1.4 2010/06/16 12:29:30 aballier Exp $

inherit vdr-plugin flag-o-matic

DESCRIPTION="VDR plugin: Show another channel in the OSD"
HOMEPAGE="http://www.magoa.net/linux"
SRC_URI="http://home.arcor.de/andreas.regel/files/osdpip/${P}.tgz"

KEYWORDS="~amd64 x86"
SLOT="0"
LICENSE="GPL-2"
IUSE=""

DEPEND=">=media-video/vdr-1.4.0
	>=media-libs/libmpeg2-0.4.0
	>=media-video/ffmpeg-0.4.9
	"

#PATCHES=("${FILESDIR}/${P}-vdr-1.5.0.diff")
PATCHES=( "${FILESDIR}/${P}-avutil50.patch" )

src_unpack() {
	vdr-plugin_src_unpack

	sed -i Makefile \
	  -e 's+^FFMDIR.*$+FFMDIR = /usr/include/ffmpeg+' \
	  -e 's+-I\$(FFMDIR)/libavcodec+-I$(FFMDIR)+' \
	  -e 's+-L\$(FFMDIR)/libavcodec++'

	if has_version ">=media-video/ffmpeg-0.4.9_p20080326" ; then
		#epatch "${FILESDIR}/${P}-ffmpeg-0.4.9_p20080326-new_header.diff"
		sed -i Makefile -e 's/#WITH_NEW_FFMPEG_HEADERS/WITH_NEW_FFMPEG_HEADERS/'
	fi
	# UINT64_C is needed by ffmpeg headers
	append-flags -D__STDC_CONSTANT_MACROS
}
