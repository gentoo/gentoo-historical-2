# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/kino/kino-0.6.4.ebuild,v 1.7 2004/06/25 00:42:23 agriffis Exp $

inherit eutils

DESCRIPTION="Kino is a non-linear DV editor for GNU/Linux"
HOMEPAGE="http://kino.schirmacher.de/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 sparc"

DEPEND="x11-libs/gtk+
	dev-libs/glib
	gnome-base/gnome-libs
	media-libs/imlib
	dev-libs/libxml2
	media-libs/audiofile
	media-sound/esound
	sys-libs/libraw1394
	sys-libs/libavc1394
	media-libs/libdv
	quicktime? ( virtual/quicktime )"

src_unpack() {
	unpack ${A}
	epatch ${FILESDIR}/kino_gcc33_fix
}

src_compile() {
	local myconf
	use quicktime && myconf="--with-quicktime"

	./configure ${myconf} \
		--host=${CHOST} \
		--prefix=/usr \
		--infodir=/usr/share/info \
		--mandir=/usr/share/man \
		--disable-dependency-tracking \
		--disable-debug || die

	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
}

pkg_postinst() {
	echo "To use kino, it is recommed that you also install"
	echo "media-video/mjpegtools"
}
