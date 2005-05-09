# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-client/links/links-2.1_pre17-r1.ebuild,v 1.4 2005/05/09 20:41:50 vanquirius Exp $

inherit eutils

DESCRIPTION="links is a fast lightweight text tand graphic web-browser"
HOMEPAGE="http://atrey.karlin.mff.cuni.cz/~clock/twibright/links/"
# To handle pre-version ...
MY_P="${P/_/}"
S="${WORKDIR}/${MY_P}"
SRC_URI="${HOMEPAGE}/download/${MY_P}.tar.bz2
	mirror://gentoo/${MY_P}-utf8.diff.bz2"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86"
IUSE="directfb ssl javascript png X gpm tiff fbcon svga jpeg unicode livecd"

# Note: if X or fbcon usegflag are enabled, links will be built in graphic
# mode. libpng is required to compile links in graphic mode
# (not required in text mode), so let's add libpng for X? and fbcon?

# We've also made USE=livecd compile in graphics mode.  This closes bug #75685.

RDEPEND="ssl? ( >=dev-libs/openssl-0.9.6c )
	gpm? ( sys-libs/gpm )
	javascript? ( >=sys-devel/flex-2.5.4a )
	png? ( >=media-libs/libpng-1.2.1 )
	jpeg? ( >=media-libs/jpeg-6b )
	tiff? ( >=media-libs/tiff-3.5.7 )
	svga? ( >=media-libs/svgalib-1.4.3
		>=media-libs/libpng-1.2.1 )
	X? ( virtual/x11
		>=media-libs/libpng-1.2.1 )
	directfb? ( dev-libs/DirectFB )
	fbcon? ( >=media-libs/libpng-1.2.1
		sys-libs/gpm )
	livecd? ( >=media-libs/jpeg-6b
		>=media-libs/libpng-1.2.1
		sys-libs/gpm )
	sys-libs/zlib
	virtual/libc
	sys-libs/ncurses"

DEPEND="${RDEPEND}
	sys-devel/automake
	sys-devel/autoconf
	sys-devel/gcc
	dev-util/pkgconfig"

PROVIDE="virtual/textbrowser"

pkg_setup (){

	if ! use gpm && use fbcon ; then
		einfo
		einfo "gpm has been installed since you have included fbcon in your USE flags."
		einfo "The links framebuffer driver requires gpm in order to compile."
		einfo
	fi

}

src_unpack (){
	unpack ${A}; cd ${S}

	if use unicode ; then
		epatch ${WORKDIR}/${MY_P}-utf8.diff
		export LANG=C
		cd ${S}/intl && ./gen-intl && cd .. || die "gen-intl filed"
	fi
}

src_compile (){
	local myconf

	if use X || use fbcon || use directfb || use svga || use livecd; then
		myconf="${myconf} --enable-graphics"
	fi

	# Note: --enable-static breaks.

	# Note: ./configure only support 'gpm' features auto-detection, so
	# we use the autoconf trick
	( use gpm || use fbcon || use livecd ) || export ac_cv_lib_gpm_Gpm_Open="no"

	export LANG=C

	if use fbcon || use livecd; then
		myconf="${myconf} --with-fb"
	else
		myconf="${myconf} --without-fb"
	fi

	econf \
		$(use_with X x) \
		$(use_with png libpng) \
		$(use_with jpeg libjpeg) \
		$(use_with tiff libtiff) \
		$(use_with svga svgalib) \
		$(use_with directfb) \
		$(use_with livecd libjpeg) \
		$(use_with ssl) \
		$(use_enable javascript) \
		${myconf} || die "configure failed"
	emake || die "make failed"
}

src_install (){
	einstall

	# Only install links icon if X driver was compiled in ...
	use X && doicon graphics/links.xpm

	dodoc AUTHORS BUGS ChangeLog INSTALL NEWS README SITES TODO
	dohtml doc/links_cal/*

	# Install a compatibility symlink links2:
	dosym links /usr/bin/links2
}


pkg_postinst() {

	if use svga
	then
		einfo "You had the svga USE flag enabled, but for security reasons"
		einfo "the links2 binary is NOT setuid by default. In order to"
		einfo "enable links2 to work in SVGA, please change the permissions"
		einfo "of /usr/bin/links2 to enable suid."
	fi
}
