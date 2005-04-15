# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/avifile/avifile-0.7.41.20041001-r1.ebuild,v 1.9 2005/04/15 03:37:46 geoman Exp $

inherit eutils flag-o-matic

MAJ_PV=${PV:0:3}
MIN_PV=${PV:0:6}
MY_P="${PN}-${MAJ_PV}-${MIN_PV}"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="Library for AVI-Files"
HOMEPAGE="http://avifile.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0.7"

#-sparc: 0.7.41 - dsputil_init_vis undefined - eradicator
KEYWORDS="~alpha amd64 ~arm ~ia64 -mips -sparc x86"
IUSE="3dnow X alsa avi debug divx4linux dvd esd mmx oggvorbis qt sdl sse static truetype xv zlib"

DEPEND=">=media-libs/jpeg-6b
	x86? ( divx4linux? ( >=media-libs/divx4linux-20030428 )
		>=media-libs/win32codecs-0.90 )
	>=media-video/ffmpeg-0.4
	=media-libs/xvid-1*
	>=media-sound/lame-3.90
	>=media-libs/audiofile-0.2.3
	>=sys-apps/sed-4
	>=media-sound/madplay-0.14.2b
	>=sys-devel/patch-2.5.9
	truetype? ( >=media-libs/freetype-2.1 )
	xv? ( virtual/x11 )
	sdl? ( >=media-libs/libsdl-1.2.2 )
	dvd? ( >=media-libs/a52dec-0.7 )
	zlib? ( >=sys-libs/zlib-1.1.3 )
	oggvorbis? ( >=media-libs/libvorbis-1.0 )
	X? ( virtual/x11 virtual/xft )
	qt? ( >=x11-libs/qt-3.0.3 )
	alsa? ( >=media-libs/alsa-lib-0.9.0_rc2 )
	esd? ( >=media-sound/esound-0.2.28 )"

src_unpack() {
	unpack ${A}
	use qt || sed -i 's/qt[a-z]*//g' ${S}/samples/Makefile.am

	# make sure pkgconfig file is correct #53183
	cd ${S}
	epatch ${FILESDIR}/throw.patch
	epatch ${FILESDIR}/${PN}-${PV}-gcc2.patch
	use sparc && epatch ${FILESDIR}/${P}-sparc.patch
	rm -f avifile.pc
	sed -i "/^includedir=/s:avifile$:avifile-${PV:0:3}:" avifile.pc.in \
		|| die "sed failed (avifile.pc.in)"
	sed -e "s:| sed s/-g//::" -i configure || die "sed failed (-g)"
	# Fix qt detection
	sed -i \
		-e "s:extern \"C\" void exit(int);:/* extern \"C\" void exit(int); */:" \
		configure || die "sed failed (qt detection)"
	# Fix hardcoded Xrender linking, bug #68899
	if ! use X; then
		sed -e 's/-lXrender//g' -i lib/video/Makefile.* \
		|| die "sed failed (Xrender)"
	fi
	# adding CFLAGS by default which exists only for x86 is no good idea
	# but I can't get it through gcc 3.4.3 without omit-frame-pointer
	find . -name "Makefile.in" | while read file; do
		sed -e "s/^AM_CFLAGS = .*/AM_CFLAGS = -fomit-frame-pointer/" -i $file
	done
}

src_compile() {
	local myconf="--enable-oss --disable-xvid --enable-xvid4"
	local kdepre=""

	if [ "$XINERAMA" = "NO" ]; then
		myconf="${myconf} --disable-xinerama"
	fi

	if [ "$DPMS" = "NO" ]; then
		myconf="${myconf} --disable-dpms"
	fi

	if [ "$V4L" = "NO" ]; then
		myconf="${myconf} --disable-v4l"
	fi

	if [ "$SUN" = "NO" ]; then
		myconf="${myconf} --disable-sunaudio"
	fi

	if [ "$SBLIVE" = "NO" ]; then
		myconf="${myconf} --disable-ac3passthrough"
	fi

	use debug \
		&& myconf="${myconf} --enable-loader-out" \
		|| myconf="${myconf} --enable-quiet"

	( use mmx || use sse || use 3dnow ) && myconf="${myconf} --enable-x86opt"

	if [ "$MGA" = "NO" ]; then
		myconf="${myconf} --disable-mga"
	fi

	if [ "$DMALLOC" = "YES" ]; then
		myconf="${myconf} --with-dmallocth"
	fi

	use qt \
		&& myconf="${myconf} --with-qt-prefix=${QTDIR}" \
		|| myconf="${myconf} --without-qt"

	# Make sure we include freetype2 headers before freetype1 headers, else Xft2
	# borks, bug #11941.
	export C_INCLUDE_PATH="${C_INCLUDE_PATH}:/usr/include/freetype2"
	export CPLUS_INCLUDE_PATH="${CPLUS_INCLUDE_PATH}:/usr/include/freetype2"

	filter-flags "-momit-leaf-frame-pointer"

	export FFMPEG_CFLAGS="${CFLAGS}"

	econf \
		`use_enable static` \
		`use_enable truetype freetype2` \
		`use_enable xv` \
		`use_enable sdl` `use_enable sdl sdltest` \
		`use_enable dvd a52` `use_enable dvd ffmpeg-a52` \
		`use_enable zlib libz` \
		`use_enable oggvorbis vorbis` `use_enable oggvorbis oggtest` `use_enable oggvorbis vorbistest` \
		`use_with X x` `use_enable X xft` \
		--enable-samples \
		--disable-vidix \
		--with-fpic \
		--enable-lame-bin \
		${myconf} \
		|| die
	emake || die
}

src_install() {
	use avi && dodir /usr/$(get_libdir)/win32

	make DESTDIR="${D}" install || die

	dodoc README INSTALL
	cd doc
	dodoc CREDITS EXCEPTIONS TODO VIDEO-PERFORMANCE WARNINGS KNOWN_BUGS
}

src_test() {
	ewarn "Testing disabled for this ebuild."
}

pkg_postinst() {
	if use qt; then # else no aviplay built
		einfo "In order to use certain video modes, you must be root"
		einfo "chmod +s /usr/bin/aviplay to suid root"
		einfo "As this is considered a security risk on multiuser"
		einfo "systems, this is not done by default"
	fi
}
