# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/quicktime4linux/quicktime4linux-2.0.4-r1.ebuild,v 1.1 2005/10/14 12:39:01 flameeyes Exp $

inherit flag-o-matic eutils toolchain-funcs

DESCRIPTION="quicktime library for linux"
HOMEPAGE="http://heroinewarrior.com/quicktime.php3"
SRC_URI="mirror://sourceforge/heroines/${P}-src.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 -ppc ~x86"
IUSE=""

DEPEND="media-libs/jpeg
	media-libs/libpng
	>=media-libs/libmpeg3-1.5.1
	>=media-libs/libdv-0.99
	>=media-video/ffmpeg-0.4.6
	>=media-sound/lame-3.93.1
	>=media-libs/libogg-1.0
	>=media-libs/libvorbis-1.0
	=dev-libs/glib-1.2*
	media-libs/a52dec
	media-libs/faac
	media-libs/faad2
	!virtual/quicktime
	dev-lang/nasm"
PROVIDE="virtual/quicktime"

src_unpack() {
	unpack ${A}
	cd ${S}
	rm -rf decore2 encore2 ffmpeg-0.4.6 jpeg jpeg-mmx-0.1.4 \
		lame-3.93.1 libdv-0.99 libogg-1.0 libvorbis-1.0
	ln -s /usr/include jpeg
	epatch ${FILESDIR}/${PV}-external-libs.patch
}

src_compile() {
	make CC=$(tc-getCC) MYCFLAGS="${CFLAGS}" || die
	make util CC=$(tc-getCC) MYCFLAGS="${CFLAGS}" || die
}

src_install() {
	dolib.so `uname -m`/libquicktime.so
	dolib.a  `uname -m`/libquicktime.a
	insinto /usr/include/quicktime
	doins *.h
	dodoc README
	dohtml -r docs
}
