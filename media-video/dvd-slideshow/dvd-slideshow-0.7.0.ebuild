# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/dvd-slideshow/dvd-slideshow-0.7.0.ebuild,v 1.3 2006/09/08 18:09:22 sbriesen Exp $

MY_P="${PN}_${PV}"

DESCRIPTION="DVD Slideshow - Turn your pictures into a dvd with menus!"
HOMEPAGE="http://dvd-slideshow.sourceforge.net/"
SRC_URI="mirror://sourceforge/dvd-slideshow/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

DEPEND=">=media-video/dvdauthor-0.6.9
	virtual/cdrtools
	media-libs/netpbm
	>=media-gfx/imagemagick-5.5.4
	media-video/mjpegtools
	media-video/transcode
	media-video/ffmpeg
	media-sound/lame
	media-sound/sox
	media-sound/toolame
	media-gfx/jhead"

S="${WORKDIR}/${MY_P}"

src_compile() { :; }

src_install() {
	dobin dvd-* *2slideshow
	dodoc *.txt doc/*.txt
	dohtml doc/*.html
	doman man/*
}
