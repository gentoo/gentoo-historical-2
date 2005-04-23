# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/xine-lib/xine-lib-1.0-r2.ebuild,v 1.4 2005/04/23 08:54:53 luckyduck Exp $

inherit eutils flag-o-matic gcc libtool

# This should normally be empty string, unless a release has a suffix.
MY_PKG_SUFFIX=""
MY_P=${PN}-${PV/_/-}${MY_PKG_SUFFIX}

DESCRIPTION="Core libraries for Xine movie player"
HOMEPAGE="http://xine.sourceforge.net/"
SRC_URI="mirror://sourceforge/xine/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="1"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ppc ~ppc64 ~sparc x86"
IUSE="aalib libcaca arts cle266 esd win32codecs nls dvd X directfb vorbis alsa gnome sdl speex theora ipv6 altivec opengl aac fbcon ffmpeg xv xvmc nvidia i8x0 samba dxr3 vidix png mng flac oss v4l xinerama"
RESTRICT="nostrip"

RDEPEND="vorbis? ( media-libs/libvorbis )
	X? ( virtual/x11 )
	win32codecs? ( >=media-libs/win32codecs-0.50 )
	esd? ( media-sound/esound )
	dvd? ( >=media-libs/libdvdcss-1.2.7 )
	arts? ( kde-base/arts )
	alsa? ( media-libs/alsa-lib )
	aalib? ( media-libs/aalib )
	directfb? ( >=dev-libs/DirectFB-0.9.9 )
	gnome? ( >=gnome-base/gnome-vfs-2.0 )
	flac? ( >=media-libs/flac-1.0.4 )
	sdl? ( >=media-libs/libsdl-1.1.5 )
	>=media-libs/libfame-0.9.0
	theora? ( media-libs/libtheora )
	speex? ( media-libs/speex )
	libcaca? ( media-libs/libcaca )
	samba? ( net-fs/samba )
	png? ( media-libs/libpng )
	mng? ( media-libs/libmng )
	ffmpeg? ( >=media-video/ffmpeg-0.4.9_p20050226-r1 )
	!=media-libs/xine-lib-0.9.13*"
DEPEND="${RDEPEND}
	v4l? ( sys-kernel/linux-headers )
	>=sys-devel/automake-1.7
	>=sys-devel/autoconf-2.59
	dev-util/pkgconfig
	nls? ( sys-devel/gettext )"

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}
	cd ${S}

	# Adds --disable- params
	epatch ${FILESDIR}/${PN}-configure-checks.patch

	# Fix check for location of XvMC.h file
	epatch ${FILESDIR}/${PN}-configure-xvmc-header.patch

	# plasmaroo: Kernel 2.6 headers patch
	epatch ${FILESDIR}/${PN}-1_rc7-2.6.patch

	# fixes bad configure stuff
	# for xv handling
	epatch ${FILESDIR}/${PN}-configure.ac.patch

	epatch ${FILESDIR}/${PN}-1_rc7-pic.patch

	# Fix detection of sparc64 systems
	use sparc && epatch ${FILESDIR}/xine-lib-1_rc7-configure-sparc.patch

	epatch ${FILESDIR}/${PN}-XSA-2004-8.patch

	elibtoolize

	# Makefile.ams and configure.ac get patched, so we need to rerun
	# autotools
	export WANT_AUTOCONF=2.5
	export WANT_AUTOMAKE=1.7
	aclocal -I m4 || die "aclocal failed"
	autoheader || die "autoheader failed"
	automake -afc || die "automake failed"
	autoconf || die "autoconf failed"

	# Fix detection of hppa2.0 and hppa1.1 CHOST
	use hppa && sed -e 's/hppa-/hppa*-linux-/' -i ${S}/configure

	libtoolize --copy --force || die "libtoolize failed"
}

src_compile() {

	#filter dangerous compile CFLAGS
	strip-flags

	#prevent quicktime crashing
	append-flags -frename-registers

	use x86 && has_pic && append-flags -UHAVE_MMX

	if [ "`gcc-major-version`" -ge "3" -a "`gcc-minor-version`" -ge "4" ]; then
		append-flags -fno-web #49509
		filter-flags -fno-unit-at-a-time #55202
		append-flags -funit-at-a-time #55202
	fi

	is-flag -O? || append-flags -O1 #31243

	# fix build errors with sse2 #49482
	if use x86 ; then
		if [ `gcc-major-version` -eq 3 ] ; then
			append-flags -mno-sse2 `test_flag -mno-sse3`
			filter-mfpmath sse
		fi
	fi

	local myconf

	# the win32 codec path should ignore $(get_libdir) and always use lib
	use win32codecs \
		&& myconf="${myconf} --with-w32-path=/usr/$(get_libdir)/win32" \
		|| myconf="${myconf} --disable-asf"

	use sparc \
		&& myconf="${myconf} --build=${CHOST}"

	# enable/disable appropiate optimizations on sparc
	[ "${PROFILE_ARCH}" == "sparc64" ] \
		&& myconf="${myconf} --enable-vis"
	[ "${PROFILE_ARCH}" == "sparc" ] \
		&& myconf="${myconf} --disable-vis"

	# Fix compilation-errors on PowerPC #45393 & #55460 & #68251
	if use ppc || use ppc64 ; then
		append-flags -U__ALTIVEC__
		myconf="${myconf} `use_enable altivec`"
	fi

	# The default CFLAGS (-O) is the only thing working on hppa.
	if use hppa && [ "`gcc-version`" != "3.4" ] ; then
		unset CFLAGS
	else
		append-flags -ffunction-sections
	fi

	if use xvmc; then
		count="0"
		use nvidia && count="`expr ${count} + 1`"
		use i8x0 && count="`expr ${count} + 1`"
		use cle266 && count="`expr ${count} + 1`"
		if [ "${count}" -gt "1" ]; then
			eerror "Invalid combination of USE flags"
			eerror "When building support for xvmc, you may only"
			eerror "include support for one video card:"
			eerror "   nvidia, i8x0, cle266"
			eerror ""
			die "emerge again with different USE flags"
		fi

		use nvidia && xvmclib="XvMCNVIDIA"
		use i8x0 && xvmclib="I810XvmC"
		use cle266 && xvmclib="viaXvMC"

		if [ -n "${xvmclib}" ]; then
			if [ -f "${ROOT}/usr/$(get_libdir)/libXvMC.so" -o -f "${ROOT}/usr/$(get_libdir)/libXvMC.a" ]; then
				myconf="${myconf} --with-xvmc-path=${ROOT}/usr/$(get_libdir) --with-xxmc-path=${ROOT}/usr/$(get_libdir) --with-xvmc-lib=${xvmclib} --with-xxmc-lib=${xvmclib}"
			elif [ -f "${ROOT}/usr/X11R6/$(get_libdir)/libXvMC.so" -o -f "${ROOT}/usr/X11R6/$(get_libdir)/libXvMC.a" ]; then
				myconf="${myconf} --with-xvmc-path=${ROOT}/usr/X11R6/$(get_libdir) --with-xxmc-path=${ROOT}/usr/X11R6/$(get_libdir) --with-xvmc-lib=${xvmclib} --with-xxmc-lib=${xvmclib}"
			else
				ewarn "Couldn't find libXvMC.  Disabling xvmc support."
			fi
		fi
	fi

	if use xv; then
		if [ -f "${ROOT}/usr/$(get_libdir)/libXv.so" ]; then
			myconf="${myconf} --with-xv-path=${ROOT}/usr/$(get_libdir)"
		elif [ -f "${ROOT}/usr/$(get_libdir)/libXv.a" ]; then
			myconf="${myconf} --enable-static-xv --with-xv-path=${ROOT}/usr/$(get_libdir)"
		elif [ -f "${ROOT}/usr/X11R6/$(get_libdir)/libXv.so" ]; then
			myconf="${myconf} --with-xv-path=${ROOT}/usr/X11R6/$(get_libdir)"
		elif [ -f "${ROOT}/usr/X11R6/$(get_libdir)/libXv.a" ]; then
			myconf="${myconf} --enable-static-xv --with-xv-path=${ROOT}/usr/X11R6/$(get_libdir)"
		else
			eerror "Couldn't find your libXv.  Did you set USE="xv" when you emerged xorg-x11?"
			die "Couldn't find libXv."
		fi
	fi

	use ffmpeg && myconf="${myconf} --with-external-ffmpeg=/usr"

	econf \
		$(use_enable nls) \
		$(use_enable ipv6) \
		$(use_enable samba) \
		\
		$(use_enable mng) \
		$(use_enable png) \
		\
		$(use_enable aac faad) \
		$(use_enable flac) \
		$(use_with vorbis ogg) $(use_with vorbis ) \
		\
		$(use_with X x) \
		$(use_enable xinerama) \
		$(use_enable vidix) \
		$(use_enable dxr3) \
		$(use_enable directfb) \
		$(use_enable fbcon fb) \
		$(use_enable opengl) \
		$(use_enable aalib) \
		$(use_enable libcaca caca) \
		$(use_enable sdl) \
		\
		$(use_enable oss) \
		$(use_enable alsa) \
		$(use_enable arts) \
		$(use_enable esd) \
		${myconf} \
		--disable-dependency-tracking || die "Configure failed"

		#$(use_with dvdnav external-dvdnav) \
		#$(use_enable macos macosx-video) $(use_enable macos coreaudio) \
		# This will be added when polypaudio will be added to portage.
		# $(use_enable polypaudio)

	emake -j1 || die "Parallel make failed"
}

src_install() {
	make DESTDIR="${D}" install || die "Install failed"

	# Xine's makefiles install some file incorrectly. (Gentoo bug #8583, #16112).
	dodir /usr/share/xine/libxine1/fonts
	mv ${D}/usr/share/*.xinefont.gz ${D}/usr/share/xine/libxine1/fonts/

	dodoc AUTHORS ChangeLog README TODO
	cd ${S}/doc
	dodoc dataflow.dia README*
}

pkg_postinst() {
	einfo
	einfo "Make sure to remove your ~/.xine if upgrading from"
	einfo "a pre-1.0 version."
	einfo
}
