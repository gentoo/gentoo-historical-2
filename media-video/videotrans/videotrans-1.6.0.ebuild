# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/videotrans/videotrans-1.6.0.ebuild,v 1.1 2008/02/04 00:58:17 sbriesen Exp $

inherit eutils

DESCRIPTION="A package to convert movies to DVD format and to build DVDs with."
HOMEPAGE="http://videotrans.sourceforge.net/"
SRC_URI="mirror://sourceforge/videotrans/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"

KEYWORDS="~amd64 ~ppc ~x86"

IUSE=""

DEPEND="media-video/ffmpeg
	media-video/mplayer
	media-video/mjpegtools
	media-video/dvdauthor
	media-gfx/imagemagick"

RDEPEND="${DEPEND}
	www-client/lynx
	app-shells/bash
	sys-devel/bc"

pkg_setup() {
	if ! built_with_use media-video/mjpegtools png; then
		eerror "Please emerge media-video/mjpegtools with useflag 'png'."
		die "Fix USE flags and re-emerge"
	fi
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc CHANGES THANKS TODO aspects.txt
}
