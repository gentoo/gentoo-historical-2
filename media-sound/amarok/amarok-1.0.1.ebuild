# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/amarok/amarok-1.0.1.ebuild,v 1.1 2004/07/05 23:11:47 fvdpol Exp $

inherit kde eutils

DESCRIPTION="amaroK is a media player for KDE"
HOMEPAGE="http://amarok.sourceforge.net/"
SRC_URI="mirror://sourceforge/amarok/${P}.tar.bz2"
RESTRICT="nomirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~amd64"
IUSE="cjk gstreamer xmms arts opengl"

DEPEND=">=kde-base/kdemultimedia-3.2
	gstreamer? ( >=media-libs/gst-plugins-0.8.1 )
	opengl? ( virtual/opengl )
	xmms? ( >=media-sound/xmms-1.2 )
	>=dev-util/pkgconfig-0.9.0
	>=media-libs/taglib-0.95"
need-kde 3.2

src_unpack() {
	if  ! use arts && ! use gstreamer
	then
		die "You must enable either Arts or Gstreamer"
	fi

	kde_src_unpack
	#CJK mp3 tag fix
	use cjk && epatch ${FILESDIR}/amarok-1.0-cjk-a.diff
}

src_compile() {
	PREFIX="`kde-config --prefix`"
	myconf="`use_with arts` `use_with gstreamer` `use_with opengl`"

	kde_src_compile myconf configure make || die
}

