# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/transcode/transcode-1.0.0_beta3.ebuild,v 1.1 2005/04/27 11:14:34 flameeyes Exp $

inherit libtool flag-o-matic eutils multilib

MY_P="${P/_/}"
S=${WORKDIR}/${MY_P}
DESCRIPTION="video stream processing tool"
HOMEPAGE="http://www.transcoding.org/cgi-bin/transcode"
SRC_URI="http://www.jakemsr.com/transcode/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="X 3dnow a52 avi altivec divx4linux dv dvdread mp3 fame truetype \
	gtk imagemagick jpeg lzo mjpeg mpeg mmx network ogg vorbis pvm quicktime \
	sdl sse sse2 theora v4l xvid xml2 ffmpeg"

RDEPEND="a52? ( >=media-libs/a52dec-0.7.4 )
	dv? ( >=media-libs/libdv-0.99 )
	dvdread? ( >=media-libs/libdvdread-0.9.0 )
	>=media-video/ffmpeg-0.4.9_pre1
	xvid? ( >=media-libs/xvid-1.0.2 )
	mjpeg? ( >=media-video/mjpegtools-1.6.2-r3 )
	lzo? ( >=dev-libs/lzo-1.08 )
	fame? ( >=media-libs/libfame-0.9.1 )
	imagemagick? ( >=media-gfx/imagemagick-5.5.6.0 )
	media-libs/netpbm
	media-libs/libexif
	X? ( virtual/x11 )
	avi? ( >=media-video/avifile-0.7.41.20041001 )
	divx4linux? ( >=media-libs/divx4linux-20030428 )
	mpeg? ( media-libs/libmpeg3 )
	mp3? ( >=media-sound/lame-3.93 )
	sdl? ( media-libs/libsdl )
	quicktime? ( >=media-libs/libquicktime-0.9.3 )
	vorbis? ( media-libs/libvorbis )
	ogg? ( media-libs/libogg )
	theora? ( media-libs/libtheora )
	jpeg? ( media-libs/jpeg )
	gtk? ( =x11-libs/gtk+-1.2* )
	truetype? ( >=media-libs/freetype-2 )
	pvm? ( >=sys-cluster/pvm-3.4 )
	ffmpeg? ( >=media-video/ffmpeg-0.4.9_p20050226-r3 )
	|| ( sys-libs/glibc dev-libs/libiconv )"

DEPEND="${RDEPEND}
	x86? ( >=dev-lang/nasm-0.98.36 )
	=sys-devel/gcc-3*"

pkg_setup() {
	if has_version xorg-x11 && ! built_with_use xorg-x11 xv; then
		die "You need xv support to compile transcode."
	fi
}

src_unpack() {
	unpack ${A}
	cd ${S}

	libtoolize --copy --force || die "libtoolize failed"
	autoreconf -i || die "autoreconf failed"

	elibtoolize	# fix invalid paths in .la files of plugins
}

src_compile() {
	filter-flags -maltivec -mabi=altivec -momit-leaf-frame-pointer
	use ppc && append-flags -U__ALTIVEC__

	if use pvm; then
		if use sparc; then
			myconf="${myconf} --enable-pvm3 \
				--with-pvm3-lib=${PVM_ROOT}/lib/LINUXSPARC \
				--with-pvm3-include=${PVM_ROOT}/include"
		else
			myconf="${myconf} --enable-pvm3 \
				--with-pvm3-lib=${PVM_ROOT}/lib/LINUX \
				--with-pvm3-include=${PVM_ROOT}/include"
		fi
	fi

	use xvid \
		&& myconf="${myconf} --with-default-xvid=xvid4"

	append-flags -DDCT_YUV_PRECISION=1
	econf \
		$(use_enable mmx) \
		$(use_enable 3dnow) \
		$(use_enable sse) \
		$(use_enable sse2) \
		$(use_enable altivec) \
		\
		$(use_enable network netstream) \
		$(use_enable truetype freetype2) \
		$(use_enable v4l) \
		$(use_enable avi avifile) \
		$(use_enable mp3 lame) \
		$(use_enable ogg) \
		$(use_enable vorbis) \
		$(use_enable theora) \
		$(use_enable dvdread libdvdread) \
		$(use_enable dv libdv) \
		$(use_enable quicktime libquicktime) \
		$(use_enable lzo) \
		$(use_enable a52) \
		$(use_enable mpeg libmpeg3) \
		$(use_enable xml2 libxml2) \
		$(use_enable mjpeg mjpegtools) \
		$(use_enable sdl) \
		$(use_enable gtk) \
		$(use_enable fame libfame) \
		$(use_enable imagemagick) \
		$(use_enable jpeg libjpeg) \
		--with-mod-path=/usr/$(get_libdir)/transcode \
		$(use_with X x) \
		$(use_with ffmpeg libpostproc-builddir "${ROOT}/usr/$(get_libdir)") \
		${myconf} \
		|| die

	emake -j1 all || die

	if use pvm; then
		sed -i -e "s:\${exec_prefix}/bin/pvmgs:\$(DESTDIR)/\${exec_prefix}/bin/pvmgs:" ${S}/pvm3/Makefile || die
	fi
}

src_install () {
	make \
		DESTDIR=${D} \
		install || die

	dodoc AUTHORS ChangeLog README TODO
}
