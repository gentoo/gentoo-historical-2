# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libsdl/libsdl-1.2.6-r2.ebuild,v 1.7 2003/12/02 08:00:05 seemant Exp $

DESCRIPTION="Simple Direct Media Layer"
HOMEPAGE="http://www.libsdl.org/"
SRC_URI="http://www.libsdl.org/release/SDL-${PV}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="x86 ~alpha ~ppc ~sparc hppa ~amd64"
IUSE="oss alsa esd arts nas X dga xv xinerama fbcon directfb ggi svga aalib opengl noaudio novideo nojoystick"
# if you disable audio/video/joystick and something breaks, you pick up the pieces

RDEPEND=">=media-libs/audiofile-0.1.9
	alsa? ( media-libs/alsa-lib )
	esd? ( >=media-sound/esound-0.2.19 )
	arts? ( kde-base/arts )
	nas? ( media-libs/nas virtual/x11 )
	X? ( >=x11-base/xfree-4.3.0 )
	directfb? ( >=dev-libs/DirectFB-0.9.19 )
	ggi? ( >=media-libs/libggi-2.0_beta3 )
	svga? ( >=media-libs/svgalib-1.4.2 )
	aalib? ( media-libs/aalib )
	opengl? ( virtual/opengl )"
DEPEND="${RDEPEND}
	>=sys-apps/sed-4"
	# Removed temporarily
	#x86? ( dev-lang/nasm )"

S=${WORKDIR}/SDL-${PV}

src_unpack() {
	unpack ${A}
	cd ${S}
	# this should fix Bug 31235
	# Cannot use epatch as this patch fails on the dry-run -- perhaps the
	# patch needs to be regenerated?
	ebegin "applying ${P}-fullscreen.patch..."
	patch -p1 -s< ${FILESDIR}/${P}-fullscreen.patch || die
	eend 0

	sed -i \
		-e 's:head -1:head -n 1:' configure || \
			die "sed configure failed"
}

src_compile() {

	local myconf=""
	[ `use noaudio` ] && myconf="${myconf} --disable-audio"
	[ `use novideo` ] \
		&& myconf="${myconf} --disable-video" \
		|| myconf="${myconf} --enable-video-dummy"
	[ `use nojoystick` ] && myconf="${myconf} --disable-joystick"

	# asm is b0rken in 1.2.6
	# http://www.libsdl.org/pipermail/sdl/2003-October/057304.html
	# `use_enable x86 nasm` \
	econf \
		--enable-events \
		--enable-cdrom \
		--enable-threads \
		--enable-timers \
		--enable-endian \
		--enable-file \
		`use_enable oss` \
		`use_enable alsa` \
		`use_enable esd` \
		`use_enable arts` \
		`use_enable nas` \
		--disable-nasm \
		`use_enable X video-x11` \
		`use_enable dga` \
		`use_enable xv video-x11-xv` \
		`use_enable xinerama video-x11-xinerama` \
		`use_enable dga video-dga` \
		`use_enable fbcon video-fbcon` \
		`use_enable directfb video-directfb` \
		`use_enable ggi video-ggi` \
		`use_enable svga video-svga` \
		`use_enable aalib video-aalib` \
		`use_enable opengl video-opengl` \
		${myconf} || die
	emake || die "emake failed"
}

src_install() {
	make DESTDIR=${D} install || die "make install failed"
	preplib
	dodoc BUGS CREDITS README README-SDL.txt README.CVS TODO WhatsNew || \
		die "dodoc failed"
	dohtml -r ./ || die "dohtml failed"
}
