# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/ffmpeg/ffmpeg-0.4.8.20040322-r1.ebuild,v 1.7 2004/06/25 22:52:45 morfic Exp $

inherit eutils flag-o-matic gcc

# TODO: --enablea52bin breaks compile

DESCRIPTION="Complete solution to record, convert and stream audio and video. Includes libavcodec."
HOMEPAGE="http://ffmpeg.sourceforge.net/"
PDATE=${PV##*.}
MY_PV=${PV%.*}
S=${WORKDIR}/${PN}-${PDATE}
SRC_URI="http://download.videolan.org/pub/videolan/vlc/0.7.1/contrib/ffmpeg-${PDATE}.tar.bz2"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc ~alpha ~amd64 ~ia64"
IUSE="mmx altivec encode oggvorbis doc faad faac dvd static sdl imlib truetype"

DEPEND="encode? ( >=media-sound/lame-3.92 )
	oggvorbis? ( >=media-libs/libvorbis-1.0-r1 )
	doc? ( >=app-text/texi2html-1.64 )
	faad? ( >=media-libs/faad2-1.1 )
	!ia64? ( !alpha? ( faac? ( >=media-libs/faac-1.23 ) ) )
	dvd? ( >=media-libs/a52dec-0.7.4 )
	sdl? ( >=media-libs/libsdl-1.2.5 )
	imlib? ( >=media-libs/imlib2-1.0.6 )
	truetype? ( >=media-libs/freetype-2.1.2 )
	!<media-video/mplayer-1.0_pre3-r1"

src_unpack() {
	unpack ${A} || die
	cd ${S}

	# for some reason it tries to #include <X11/Xlib.h>,b ut doesn't use it
	cd ${S}
	sed -i s:\#define\ HAVE_X11:\#define\ HAVE_LINUX: ffplay.c

    #this will allow ffmpeg to be compiled with gcc-3.4.x fixing bug #49383
	if [ "`gcc-major-version`" -ge "3" -a "`gcc-minor-version`" -ge "4" ]
    then
		einfo "Compiler used: gcc-3.4.x Applying patch conditionally."
		epatch ${FILESDIR}/0.4.8-gcc3.4-magicF2W.patch
	fi
}

src_compile() {
	filter-flags -fforce-addr -fPIC
	# fixes bug #16281
	use alpha && append-flags -fPIC
	use amd64 && append-flags -fPIC
	use ppc && append-flags -fPIC

	local myconf
	#myconf="${myconf} --disable-opts --enable-pp --enable-shared-pp"
	myconf="${myconf} --disable-opts --enable-pp"
	use mmx || myconf="${myconf} --disable-mmx"
	use encode && myconf="${myconf} --enable-mp3lame"
	use oggvorbis && myconf="${myconf} --enable-vorbis"
	use faad && myconf="${myconf} --enable-faad --enable-faadbin"
	if ! use ia64 && ! use alpha; then
	    use faac && myconf="${myconf} --enable-faac"
	fi
	use dvd && myconf="${myconf} --enable-a52"
	use static || myconf="${myconf} --enable-shared"
	use sdl || myconf="${myconf} --disable-ffplay"
	use debug || myconf="${myconf} --disable-debug"
	use altivec || myconf="${myconf} --disable-altivec"

# Using --enable-a52bin breaks the compile
	#use dvd && myconf="${myconf} --enable-a52 --enable-a52bin"

	./configure ${myconf} \
		--prefix=/usr || die "./configure failed."
	make || die "make failed."
	use doc && make -C doc all

	filter-flags -momit-leaf-frame-pointer
	# fixes bug #45576
	./configure ${myconf} \
		--prefix=/usr || die "./configure failed."
	# Build libpostproc
	cd ${S}/libavcodec/libpostproc
	make || die "Failed to build libpostproc.a!"
	make SHARED_PP="yes" || die "Failed to build libpostproc.so!"
}

src_install() {
	make \
		DESTDIR=${D} \
		prefix=${D}/usr \
		bindir=${D}/usr/bin \
		mandir=${D}/usr/share/man \
		infodir=${D}/usr/share/info \
		install || die
	dosym /usr/lib/libavcodec-${MY_PV}.so /usr/lib/libavcodec.so

	dodoc COPYING CREDITS Changelog INSTALL README
	docinto doc
	dodoc doc/TODO doc/*.html doc/*.texi
	insinto /etc
	doins doc/ffserver.conf

	# Install libpostproc ...
	cd ${S}/libavcodec/libpostproc
	make prefix=${D}/usr \
		install || die "Failed to install libpostproc.a!"
	make prefix=${D}/usr \
		SHARED_PP="yes" \
		install || die "Failed to install libpostproc.so!"
	cd ${S}
	# Some stuff like transcode can use this one.
	dolib ${S}/libavcodec/libpostproc/libpostproc.a

	preplib /usr
}
