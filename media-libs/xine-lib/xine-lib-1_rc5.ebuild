# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/xine-lib/xine-lib-1_rc5.ebuild,v 1.5 2004/06/26 20:15:17 hansmi Exp $

inherit eutils flag-o-matic gcc libtool

# This should normally be empty string, unless a release has a suffix.
MY_PKG_SUFFIX=""

DESCRIPTION="Core libraries for Xine movie player"
HOMEPAGE="http://xine.sourceforge.net/"
SRC_URI="mirror://sourceforge/xine/${PN}-${PV/_/-}${MY_PKG_SUFFIX}.tar.gz"

LICENSE="GPL-2"
SLOT="1"
KEYWORDS="~x86 ~ppc ~hppa ~sparc ~amd64 -ia64 ~alpha"
IUSE="arts esd avi nls dvd aalib X directfb oggvorbis alsa gnome sdl speex theora ipv6"

RDEPEND="oggvorbis? ( media-libs/libvorbis )
	!amd64? ( X? ( virtual/x11 ) )
	amd64? ( X? ( || ( x11-base/xorg-x11 >=x11-base/xfree-4.3.0-r6 ) ) )
	avi? ( x86? ( >=media-libs/win32codecs-0.50
	       media-libs/divx4linux ) )
	esd? ( media-sound/esound )
	dvd? ( >=media-libs/libdvdcss-1.2.7 )
	arts? ( kde-base/arts )
	alsa? ( media-libs/alsa-lib )
	aalib? ( media-libs/aalib )
	!sparc? ( directfb? ( >=dev-libs/DirectFB-0.9.9
		    dev-util/pkgconfig ) )
	gnome? ( >=gnome-base/gnome-vfs-2.0
			dev-util/pkgconfig )
	>=media-libs/flac-1.0.4
	sdl? ( >=media-libs/libsdl-1.1.5 )
	>=media-libs/libfame-0.9.0
	>=media-libs/xvid-0.9.0
	theora? ( media-libs/libtheora )
	speex? ( media-libs/speex )"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )"

S=${WORKDIR}/${PN}-${PV/_/-}${MY_PKG_SUFFIX}

pkg_setup() {
	# Make sure that the older libraries are not installed (bug #15081).
	if [ `has_version =media-libs/xine-lib-0.9.13*` ]
	then
		eerror "Please uninstall older xine libraries.";
		eerror "The compilation cannot proceed.";
		die
	fi
}

src_unpack() {
	unpack ${A}
	cd ${S}

	# gcc2 fixes provided by <T.Henderson@cs.ucl.ac.uk> in #26534
	#epatch ${FILESDIR}/${P}-gcc2_fix.patch
	# preserve CFLAGS added by drobbins, -O3 isn't as good as -O2 most of the time
	epatch ${FILESDIR}/protect-CFLAGS.patch-${PV}
	# plasmaroo: Kernel 2.6 headers patch
	epatch ${FILESDIR}/${PN}-2.6.patch
	# force 32 bit userland
	[ ${ARCH} = "sparc" ] && epatch ${FILESDIR}/${P}-configure-sparc.patch

	# always_inline means inline-or-fail, so it's no suprise that xine-lib
	# fails to compile with gcc 3.4 when this one inline fails
	#epatch ${FILESDIR}/xine-lib-gcc34.patch

	elibtoolize #40317

	# Fix building on amd64, #49569
	#use amd64 && epatch ${FILESDIR}/configure-64bit-define.patch

	# Fix detection of hppa2.0 and hppa1.1 CHOST
	use hppa && sed -e 's/hppa-/hppa*-linux-/' -i ${S}/configure
}

src_compile() {
	filter-flags -fstack-protector
	filter-flags -fPIC
	filter-flags -fforce-addr

	# fix build errors with sse2
	if use x86 ; then
		[ "`gcc-version`" == "3.2" ] && append-flags -mno-sse2
		[ "`gcc-version`" == "3.3" ] && append-flags -mno-sse2
		[ "`gcc-version`" == "3.4" ] && append-flags -mno-sse2
	fi

	# Use the built-in dvdnav plugin.
	local myconf="--with-included-dvdnav"

	use avi	&& use x86 \
		&& myconf="${myconf} --with-w32-path=/usr/lib/win32" \
		|| myconf="${myconf} --disable-asf"

	use sparc \
		&& myconf="${myconf} --enable-vis --build=${CHOST}"

	use amd64 \
		&& myconf="${myconf} --with-xv-path=/usr/X11R6/lib"

	# Disable compiling of altivec-code if it's not in the
	# USE-flags
	if use ppc
	then
		use altivec \
			&& myconf="${myconf} --enable-altivec" \
			|| append-flags -U__ALTIVEC__
	fi

	# The default CFLAGS (-O) is the only thing working on hppa.
	use hppa \
		&& unset CFLAGS

	econf \
		`use_enable X x11` \
		`use_enable esd` \
		`use_enable nls` \
		`use_enable alsa` \
		`use_enable arts` \
		`use_enable aalib` \
		`use_enable oggvorbis ogg` `use_enable oggvorbis vorbis` \
		`use_enable sdl sdltest` \
		`use_enable ipv6` \
		`use_enable directfb` \
		${myconf} || die "Configure failed"

	emake -j1 || die "Parallel make failed"
}

src_install() {
	einstall || die "Install failed"

	# Xine's makefiles install some file incorrectly. (Gentoo bug #8583, #16112).
	dodir /usr/share/xine/libxine1/fonts
	mv ${D}/usr/share/*.xinefont.gz ${D}/usr/share/xine/libxine1/fonts/

	dodoc AUTHORS COPYING ChangeLog INSTALL README TODO
	cd ${S}/doc
	dodoc dataflow.dia README*
}

pkg_postinst() {
	einfo
	einfo "Please note, a new version of xine-lib has been installed,"
	einfo "for library consistency you need to unmerge old versions"
	einfo "of xine-lib before merging xine-ui."
	einfo
	einfo "This library version 1 is incompatible with the plugins,"
	einfo "designed for the prior library versions (such as xine-d4d,"
	einfo "xine-d5d, xine-dmd, and xine-dvdnav."
	einfo
	einfo "Also make sure to remove your ~/.xine if upgrading from"
	einfo "a previous version."
	einfo
}
