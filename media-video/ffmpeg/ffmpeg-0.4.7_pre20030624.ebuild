# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/ffmpeg/ffmpeg-0.4.7_pre20030624.ebuild,v 1.1 2003/06/26 18:29:12 raker Exp $

DESCRIPTION="Complete solution to record, convert and stream audio and video. Includes libavcodec."
SRC_URI="mirror://gentoo/ffmpeg-cvs-2003-06-24.tar.gz"
HOMEPAGE="http://ffmpeg.sourceforge.net/"

IUSE="mmx encode oggvorbis doc faad dvd static"

inherit flag-o-matic
filter-flags "-fforce-addr -fPIC"
# fixes bug #16281
use alpha && append-flags "-fPIC" 

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc ~sparc ~alpha"

DEPEND="encode? ( >=media-sound/lame-3.92 )
	oggvorbis? ( >=media-libs/libvorbis-1.0-r1 )
	doc? ( >=app-text/texi2html-1.64 )
	faad? ( >=media-libs/faad2-1.1 )
	dvd? ( >=media-libs/a52dec-0.7.4 )"

S=${WORKDIR}/ffmpeg-cvs-2003-06-24

src_unpack() {
	unpack ${A} || die
	cd ${S}
}

src_compile() {
	local myconf

	use mmx || myconf="--disable-mmx"
	use encode && myconf="${myconf} --enable-mp3lame"
	use oggvorbis && myconf="${myconf} --enable-vorbis"
	use faad && myconf="${myconf} --enable-faad --enable-faadbin"
	use dvd && myconf="${myconf} --enable-a52 --enable-a52bin"
	use static || myconf="${myconf} --enable-shared"

	./configure ${myconf} \
		--prefix=/usr || die "./configure failed."
	make || die "make failed."
	use doc && make -C doc all 
}

src_install() {
	einstall || die "Installation failed."
	dosym /usr/bin/ffmpeg /usr/bin/ffplay
	dosym /usr/lib/libavcodec-CVS-2003-06-24.so /usr/lib/libavcodec.so

	dodoc COPYING CREDITS Changelog INSTALL README
	docinto doc
	dodoc doc/TODO doc/*.html doc/*.texi
	insinto /etc
	doins doc/ffserver.conf
}
