# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-tv/nuvexport/nuvexport-0.2_pre20050221.ebuild,v 1.1 2005/02/24 04:39:01 cardoe Exp $

S=${WORKDIR}/nuvexport-0.2
DESCRIPTION="Export from mythtv recorded NuppelVideo files"
HOMEPAGE="http://www.forevermore.net/mythtv/"
SRC_URI="http://www.forevermore.net/files/nuvexport/nuvexport-0.2-cvs20050221.tar.bz2
	http://www.forevermore.net/files/nuvexport/archive/nuvexport-0.2-cvs20050221.tar.bz2"
LICENSE="as-is"
SLOT="0"

IUSE=""

KEYWORDS="~x86"
DEPEND=""
RDEPEND="dev-perl/DBI
	dev-perl/DBD-mysql
	media-video/ffmpeg
	media-video/mjpegtools
	media-video/transcode
	media-video/avidemux
	media-video/lve
	media-video/mplayer
	|| ( media-tv/mythtv media-tv/mythtv-cvs )"

pkg_setup() {
	local trans_use="$(</var/db/pkg/`best_version media-video/transcode`/USE)"
	if ! has mjpeg ${trans_use} ; then
		eerror "media-video/transcode is missing mjpeg support. Please add"
		eerror "'mjpeg' to your USE flags, and re-emerge media-video/transcode."
		die "transcode needs mjpeg support"
	fi
}

src_install() {
	einstall || die "failed to install"
}
