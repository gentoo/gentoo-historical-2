# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/ffmpeg/ffmpeg-0.4.6.ebuild,v 1.4 2003/07/12 21:12:38 aliz Exp $

DESCRIPTION="Complete solution to record, convert and stream audio and video. Includes libavcodec."
SRC_URI="mirror://sourceforge/ffmpeg/${P}.tar.gz"
HOMEPAGE="http://ffmpeg.sourceforge.net/"

IUSE="mmx encode oggvorbis doc"

inherit flag-o-matic
filter-flags -fforce-addr

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ~ppc ~sparc "

DEPEND="encode? ( >=media-sound/lame-3.92 )
		oggvorbis? ( >=media-libs/libvorbis-1.0-r1 )
		doc? ( >=app-text/texi2html-1.64 )"

S=${WORKDIR}/${P}

src_unpack() {
	unpack ${A} || die
	cd ${S}

	# ffmpeg doesn't use autoconf (etc.), so...
	patch -p0 < ${FILESDIR}/${P}-Makefiles.diff || die \
		"Patch #1 failed."
}

src_compile() {
	local myconf

	use mmx || myconf="--disable-mmx"
	use encode && myconf="${myconf} --enable-mp3lame"
	use oggvorbis && myconf="${myconf} --enable-vorbis"

	./configure ${myconf} \
		--prefix=/usr \
		--enable-shared || die "./configure failed."
	make || die "make failed."
	use doc && make -C doc all || die "make all in ./doc failed."
}

src_install() {
	einstall || die "Installation failed."
	dosym /usr/bin/ffmpeg /usr/bin/ffplay
	dosym /usr/lib/libavcodec-${PV}.so /usr/lib/libavcodec.so

	dodoc COPYING CREDITS Changelog INSTALL README
	docinto doc
	dodoc doc/TODO doc/*.html doc/*.texi
	insinto /etc
	doins doc/ffserver.conf
}
