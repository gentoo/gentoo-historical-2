# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/lives/lives-0.9.1.ebuild,v 1.2 2005/01/11 02:45:26 lu_zero Exp $

inherit flag-o-matic

DESCRIPTION="Linux Video Editing System"

HOMEPAGE="http://www.xs4all.nl/~salsaman/lives"

MY_PN=LiVES
MY_P=${MY_PN}-${PV}

SRC_URI="mirror://sourceforge/lives/${MY_P}-src.tar.bz2"

LICENSE="GPL-2"

SLOT="0"

KEYWORDS="~x86 ~ppc ~amd64"

IUSE="xmms matroska ogg theora"

DEPEND=">=media-video/mplayer-0.90-r2
		>=media-gfx/imagemagick-5.5.6
		>=dev-lang/perl-5.8.0-r12
		>=x11-libs/gtk+-2.2.1
		media-libs/gdk-pixbuf
		media-libs/libsdl
		>=media-video/ffmpeg-0.4.8
		>=media-libs/jpeg-6b-r3
		>=media-sound/sox-12.17.3-r3
		xmms? ( >=media-sound/xmms-1.2.7-r20 )
		virtual/cdrtools
		theora? ( media-libs/libtheora )
		>=dev-lang/python-2.3.4
		matroska? ( media-video/mkvtoolnix
					media-libs/libmatroska )
		ogg? ( media-sound/ogmtools )
		>=media-video/mjpegtools-1.6.2
		"

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}
}

src_compile() {
	use amd64 && append-flags -fPIC -DPIC
	econf || die
	emake || die
}

src_install() {
	emake DESTDIR=${D} install || die
	dodoc AUTHORS CHANGELOG FEATURES GETTING.STARTED
}
