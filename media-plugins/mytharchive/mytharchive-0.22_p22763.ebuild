# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/mytharchive/mytharchive-0.22_p22763.ebuild,v 1.1 2009/11/08 02:01:58 cardoe Exp $

EAPI=2
inherit qt4 mythtv-plugins

DESCRIPTION="Allows for archiving your videos to DVD."
IUSE=""
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND=">=dev-lang/python-2.3.5
		dev-python/mysql-python
		dev-python/imaging
		>=media-video/mjpegtools-1.6.2[png]
		>=media-video/dvdauthor-0.6.11
		>=media-video/ffmpeg-0.4.9
		>=app-cdr/dvd+rw-tools-5.21.4.10.8
		virtual/cdrtools
		media-video/transcode"
DEPEND="${RDEPEND}"
