# Copyright 1999-2003 Gentoo Technologies, Inc. 
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/transcode/transcode-0.6.3.20030116-r1.ebuild,v 1.1 2003/02/14 04:25:53 raker Exp $

inherit libtool flag-o-matic

# Don't build with -mfpmath=sse || -fPic or it will break. (Bug #14920)
filter-flags -mfpmath=sse 
filter-flags -fPic

IUSE="sdl mmx mpeg sse encode X quicktime avi"
MY_P=${P/.20030116/}
S=${WORKDIR}/${MY_P}
DESCRIPTION="video stream processing tool"
SRC_URI="http://www.theorie.physik.uni-goettingen.de/~ostreich/transcode/pre/${MY_P}.tar.gz"
HOMEPAGE="http://www.theorie.physik.uni-goettingen.de/~ostreich/transcode"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 -ppc"
DEPEND=">=media-libs/a52dec-0.7.3
	>=media-libs/libdv-0.9.5
	>=dev-lang/nasm-0.98.34
	>=media-libs/libdvdread-0.9.0
	>=media-video/mplayer-0.90_pre10
	>=media-video/ffmpeg-0.4.0
	>=media-libs/xvid-0.9.0
	>=media-video/mjpegtools-1.6.0
	>=dev-libs/lzo-1.08
	>=media-libs/libfame-0.9.0
	>=media-gfx/imagemagick-5.4.9.0
	=media-libs/netpbm-9.12*
	X? ( virtual/x11 )
	avi? (	>=media-video/avifile-0.7.25 )
	mpeg? ( media-libs/libmpeg3 )
	encode? ( >=media-sound/lame-3.89 )
	sdl? ( media-libs/libsdl )
	quicktime? ( media-libs/quicktime4linux media-libs/openquicktime )"

src_compile() {
	# fix invalid paths in .la files of plugins
	elibtoolize

	local myconf
	myconf="--with-dvdread"

	use mmx \
		&& myconf="${myconf} --enable-mmx"
	use mmx || ( use 3dnow || use sse ) \
		|| myconf="${myconf} --disable-mmx"
	# Dont disable mmx if 3dnow or sse are requested.

	use sse \
		&& myconf="${myconf} --enable-sse" \
		|| myconf="${myconf} --disable-sse"

	use avi \
		&& myconf="${myconf} --with-avifile-mods --enable-avifile6" \
		|| myconf="${myconf} --without-avifile-mods --disable-avifile6"

	use encode \
		&& myconf="${myconf} --with-lame" \
		|| myconf="${myconf} --without-lame"

	use mpeg \
		&& myconf="${myconf} --with-libmpeg3" \
		|| myconf="${myconf} --without-libmpeg3"

	use quicktime \
		&& myconf="${myconf} --with-qt --with-openqt" \
		|| myconf="${myconf} --without-qt --without-openqt"

	use X \
		&& myconf="${myconf} --enable-x" \
		|| myconf="${myconf} --disable-x"

	# Use the MPlayer libpostproc if present
	[ -f ${ROOT}/usr/lib/libpostproc.a ] && \
	[ -f ${ROOT}/usr/include/postprocess.h ] && \
		myconf="${myconf} --with-libpostproc-builddir=${ROOT}/usr/lib"

	econf ${myconf} || die

	# Do not use emake !!
	make all || die

	# subrip stuff
	cd contrib/subrip
	make || die
}

src_install () {

	make \
		DESTDIR=${D} \
		install || die

	dodoc AUTHORS COPYING ChangeLog README TODO

	# subrip stuff
	cd contrib/subrip
	dobin pgm2txt srttool subtitle2pgm subtitle2vobsub
	einfo ""
	einfo "This ebuild uses subtitles !!!"
	einfo ""
}
