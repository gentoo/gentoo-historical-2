# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/avidemux/avidemux-0.9_pre26.ebuild,v 1.2 2003/01/09 22:46:47 mholzer Exp $

MY_P="${P/_/}"
DESCRIPTION="Great Video editing/encoding tool"
HOMEPAGE="http://fixounet.free.fr/avidemux/"
SRC_URI="http://fixounet.free.fr/avidemux/${MY_P}.tgz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86"

S="${WORKDIR}/${MY_P}"

DEPEND="virtual/x11
	>=media-sound/mad-0.14.2b-r1
	>=media-sound/lame-3.92
	<=media-sound/esound-0.2.29
	>=media-libs/libmpeg3-1.5-r1
	>=media-libs/a52dec-0.7.4
	>=media-libs/divx4linux-20020418
	>=media-libs/freetype-2.1.2
	>=x11-libs/gtk+-1.2.10-r8
	>=media-video/mjpegtools-1.6.0-r3"

src_unpack() {
	unpack ${MY_P}.tgz || die
	gunzip -c ${FILESDIR}/ADM_vidFont.cpp.diff.gz | patch ${S}/avidemux/ADM_video/ADM_vidFont.cpp || die
}

src_compile() {
	econf --disable-warnings
	emake || die
}

 src_install() {
	make DESTDIR=${D} install || die
	dodoc AUTHORS ChangeLog History README TODO
}


