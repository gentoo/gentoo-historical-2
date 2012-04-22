# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/virtual/ffmpeg/ffmpeg-0.10.2-r1.ebuild,v 1.5 2012/04/22 12:20:47 maekke Exp $

EAPI=4

DESCRIPTION="Virtual package for FFmpeg implementation"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="~alpha amd64 arm hppa ~ia64 ~ppc ~ppc64 ~sparc x86 ~x86-fbsd"
IUSE="X +encode jpeg2k mp3 sdl theora threads truetype vaapi vdpau x264"

RDEPEND="
	|| (
		>=media-video/ffmpeg-0.10.2[X=,encode=,jpeg2k=,mp3=,sdl=,theora=,threads=,truetype=,vaapi=,vdpau=,x264=]
		>=media-video/libav-0.8.1[X=,encode=,jpeg2k=,mp3=,sdl=,theora=,threads=,truetype=,vaapi=,vdpau=,x264=]
	)
"
DEPEND=""
