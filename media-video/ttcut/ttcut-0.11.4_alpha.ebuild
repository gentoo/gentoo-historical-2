# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/ttcut/ttcut-0.11.4_alpha.ebuild,v 1.2 2007/04/22 10:49:57 genstef Exp $

inherit eutils qt4

DESCRIPTION="Tool for removing advertisements from recorded MPEG files"
HOMEPAGE="http://ttcut.tritime.org/"
SRC_URI="mirror://berlios/${PN}/${P/_/-}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="ttmpeg2"

DEPEND="$(qt4_min_version 4.1)
		>=media-libs/libmpeg2-0.4.0"

RDEPEND="${DEPEND}
		media-video/mplayer
		media-video/transcode
		media-video/ffmpeg"

S=${WORKDIR}/${PN}

src_compile() {
	if has_version ">=x11-libs/qt-4.2" && ! built_with_use x11-libs/qt qt3support ; then
		eerror "In order to compile ttcut and ttmpeg2 you need to recompile qt4 with"
		eerror "qt3support USE flag enabled."
		die "Recompile qt4 with qt3support USE flag enabled"
	fi

	if use ttmpeg2 ; then

		qmake ttmpeg2.pro -o Makefile.ttmpeg2 || \
			die "configuring ttpmeg2 failed"
		make -f Makefile.ttmpeg2 || die "emake ttmpeg2 failed"
	fi

	qmake ttcut.pro -o Makefile.ttcut || \
		die "configuring ttcut failed"
	emake -f Makefile.ttcut || die "emake failed"
}

src_install() {
	if use ttmpeg2 ; then
		dobin ttmpeg2 || die "Couldn't install ttmpeg2"
		make_desktop_entry ttmpeg2 TTMpeg2 "" "AudioVideo;Video;AudioVideoEditing" || \
			die "Couldn't make ttmpeg2 desktop entry"
	fi

	dobin ttcut || die "Couldn't install ttcut"
	make_desktop_entry ttcut TTCut "" "AudioVideo;Video;AudioVideoEditing" || \
		die "Couldn't make ttcut desktop entry"
}
