# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/kino/kino-0.7.6.ebuild,v 1.7 2006/09/25 18:12:06 calchan Exp $

inherit eutils toolchain-funcs

DESCRIPTION="Kino is a non-linear DV editor for GNU/Linux"
HOMEPAGE="http://www.kinodv.org/"
SRC_URI="mirror://sourceforge/kino/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"
IUSE="quicktime dvdr ffmpeg"

DEPEND="x11-libs/gtk+
	>=gnome-base/libglade-2
	>=gnome-base/libgnomeui-2
	>=gnome-base/libgnome-2
	>=dev-libs/glib-2
	dev-libs/libxml2
	media-libs/audiofile
	media-sound/esound
	sys-libs/libraw1394
	sys-libs/libavc1394
	>=media-libs/libdv-0.102
	media-libs/libsamplerate
	media-video/mjpegtools
	media-sound/rawrec
	ffmpeg? ( media-video/ffmpeg )
	quicktime? ( virtual/quicktime )
	dvdr? ( media-video/dvdauthor )"

RESTRICT="primaryuri"

src_unpack() {
	unpack ${A}
	cd ${S}

	# some things are getting installed into the wrong location, see #90496
	epatch ${FILESDIR}/${P}-configure.diff
	autoconf
}

src_compile() {
	econf \
		--disable-dependency-tracking \
		--disable-debug \
		$(use_with quicktime) \
		$(use_with ffmpeg avcodec) || die "configure failed"
	emake || die "make failed"
}

src_install() {
	make DESTDIR=${D} install || die "make install failed"
}
