# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/avifile/avifile-0.7.38.20030710.ebuild,v 1.5 2003/10/21 15:51:14 mholzer Exp $

MAJ_PV=${PV:0:3}
MIN_PV=${PV:0:6}
MY_P="${PN}-${MAJ_PV}-${MIN_PV}"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="Library for AVI-Files"
HOMEPAGE="http://avifile.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"
RESTRICT="nomirror"

LICENSE="GPL-2"
SLOT="0.7"
KEYWORDS="x86 ~sparc"
IUSE="static truetype xv sdl dvd mmx sse 3dnow zlib oggvorbis X qt alsa esd debug"

DEPEND=">=media-libs/jpeg-6b
	x86? ( >=media-libs/divx4linux-20030428
		>=media-libs/win32codecs-0.90 )
	>=media-video/ffmpeg-0.4
	>=media-libs/xvid-0.9.0
	>=media-sound/lame-3.90
	>=media-libs/audiofile-0.2.3
	>=sys-apps/sed-4
	>=media-sound/mad-0.14.2b
	truetype? ( >=media-libs/freetype-2.1 )
	xv? ( >=x11-base/xfree-4.2.1 )
	sdl? ( >=media-libs/libsdl-1.2.2 )
	dvd? ( >=media-libs/a52dec-0.7 )
	zlib? ( >=sys-libs/zlib-1.1.3 )
	oggvorbis? ( >=media-libs/libvorbis-1.0 )
	X? ( >=x11-base/xfree-4.2.0 virtual/xft )
	qt? ( >=x11-libs/qt-3.0.3 )
	alsa? ( >=media-libs/alsa-lib-0.9.0_rc2 )
	esd? ( >=media-sound/esound-0.2.28 )"

src_unpack() {
	unpack ${A}
	use qt || sed -i 's/qt[a-z]*//g' ${S}/samples/Makefile.am
}

src_compile() {
	epatch ${FILESDIR}/flvenc-patch
	local myconf="--enable-oss"
	local kdepre=""

	use static \
		&& myconf="${myconf} --enable-static" \
		|| myconf="${myconf} --disable-static"

	use truetype \
		&& myconf="${myconf} --enable-freetype2" \
		|| myconf="${myconf} --disable-freetype2"

	use xv \
		&& myconf="${myconf} --enable-xv" \
		|| myconf="${myconf} --disable-xv"

	if [ "$XINERAMA" = "NO" ]; then
		myconf="${myconf} --disable-xinerama"
	fi

	if [ "$DPMS" = "NO" ]; then
		myconf="${myconf} --disable-dpms"
	fi

	use sdl \
		&& myconf="${myconf} --enable-sdl" \
		|| myconf="${myconf} --disable-sdl --disable-sdltest"

	if [ "$V4L" = "NO" ]; then
		myconf="${myconf} --disable-v4l"
	fi

	if [ "$SUN" = "NO" ]; then
		myconf="${myconf} --disable-sunaudio"
	fi

	use dvd \
		&& myconf="${myconf} --enable-a52 --enable-ffmpeg-a52" \
		|| myconf="${myconf} --disable-a52 --disable-ffmpeg-a52"

	if [ "$SBLIVE" = "NO" ]; then
		myconf="${myconf} --disable-ac3passthrough"
	fi

	use debug \
		&& myconf="${myconf} --enable-loader-out" \
		|| myconf="${myconf} --enable-quiet"

	( use mmx || use sse || use 3dnow ) && myconf="${myconf} --enable-x86opt"

	use zlib \
		&& myconf="${myconf} --enable-libz" \
		|| myconf="${myconf} --disable-libz"

	use oggvorbis \
		&& myconf="${myconf} --enable-vorbis" \
		|| myconf="${myconf} --disable-vorbis --disable-oggtest --disable-vorbistest"

	if [ "$MGA" = "NO" ]; then
		myconf="${myconf} --disable-mga"
	fi

	if [ "$DMALLOC" = "YES" ]; then
		myconf="${myconf} --with-dmallocth"
	fi

	use X \
		&& myconf="${myconf} --with-x --enable-xft" \
		|| myconf="${myconf} --without-x --disable-xft"

	use qt \
		&& myconf="${myconf} --with-qt-prefix=${QTDIR}" \
		|| myconf="${myconf} --without-qt"

	# Rather not use custom ones here .. build should set as high as
	# safe by itself.
	unset CFLAGS CXXFLAGS LDFLAGS CC CXX

	# Make sure we include freetype2 headers before freetype1 headers, else Xft2
	# borks, bug #11941.
	export C_INCLUDE_PATH="${C_INCLUDE_PATH}:/usr/include/freetype2"
	export CPLUS_INCLUDE_PATH="${CPLUS_INCLUDE_PATH}:/usr/include/freetype2"

	# Fix qt detection
	cp configure configure.orig
	sed -e "s:extern \"C\" void exit(int);:/* extern \"C\" void exit(int); */:" \
		< configure.orig > configure

	econf \
		--enable-samples \
		--disable-vidix \
		--with-fpic \
		--with-gnu-ld \
		--enable-lame-bin \
		${myconf} || die
	emake || die
}

src_install() {
	dodir /usr/lib /usr/bin
	use avi && dodir /usr/lib/win32

	einstall || die

	cd ${S}
	dodoc COPYING README INSTALL
	cd doc
	dodoc CREDITS EXCEPTIONS FreeBSD LICENSING TODO
	dodoc VIDEO-PERFORMANCE WARNINGS KNOWN_BUGS
}

pkg_postinst() {
	einfo "In order to use certain video modes, you must be root"
	einfo "chmod +s /usr/bin/aviplay to suid root"
	einfo "As this is considered a security risk on multiuser"
	einfo "systems, this is not done by default"
}
