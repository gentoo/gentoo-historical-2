# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/lives/lives-0.7.1.ebuild,v 1.6 2006/11/13 15:24:21 flameeyes Exp $

DESCRIPTION="Linux Video Editing System"

HOMEPAGE="http://www.xs4all.nl/~salsaman/lives"

MY_PN=LiVES
MY_P=${MY_PN}-${PV}

SRC_URI="http://www.xs4all.nl/~salsaman/lives/${MY_P}-src.tar.bz2"

LICENSE="GPL-2"

SLOT="0"

KEYWORDS="~x86 ~ppc"

IUSE=""

DEPEND=">=media-video/mplayer-0.90-r2
		>=media-gfx/imagemagick-5.5.6
		>=dev-lang/perl-5.8.0-r12
		>=x11-libs/gtk+-2.2.1
		media-libs/gdk-pixbuf
		>=media-libs/jpeg-6b-r3
		>=media-sound/sox-12.17.3-r3
		virtual/cdrtools"

RDEPEND=""

S=${WORKDIR}/${MY_P}

src_compile() {
		econf || die
		emake || die
}

src_install() {
		einstall || die
		insinto /usr/bin
		dobin ${S}/smogrify || die
		dobin ${S}/midistart || die
		dobin ${S}/midistop || die
		dodoc AUTHORS CHANGELOG FEATURES GETTING.STARTED
}
