# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/DirectFB/DirectFB-1.1.0.ebuild,v 1.1 2007/12/02 22:22:18 vapier Exp $

inherit eutils toolchain-funcs

IUSE_VIDEO_CARDS="ati128 cle266 cyber5k i810 i830 mach64 matrox neomagic nsc nvidia radeon savage sis315 tdfx unichrome"
IUSE_INPUT_DEVICES="dbox2remote elo-input gunze h3600_ts joystick keyboard dreamboxremote linuxinput lirc mutouch none permount ps2mouse serialmouse sonypijogdial wm97xx"

DESCRIPTION="Thin library on top of the Linux framebuffer devices"
HOMEPAGE="http://www.directfb.org/"
SRC_URI="http://www.directfb.org/download/DirectFB/${P}.tar.gz
	mirror://gentoo/DirectFB-1.1.0-upstream-git-gfxdrivers-fixes.patch.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 -mips ~ppc ~ppc64 ~sh -sparc ~x86"
IUSE="debug fbcon fusion gif jpeg mmx png sdl sse sysfs truetype v4l v4l2 zlib"

#	fusion? ( >=dev-libs/linux-fusion-7.0.1 )
DEPEND="sdl? ( media-libs/libsdl )
	gif? ( media-libs/giflib )
	png? ( media-libs/libpng )
	jpeg? ( media-libs/jpeg )
	sysfs? ( sys-fs/sysfsutils )
	zlib? ( sys-libs/zlib )
	truetype? ( >=media-libs/freetype-2.0.1 )"

pkg_setup() {
	if [[ -z ${VIDEO_CARDS} ]] ; then
		ewarn "All video drivers will be built since you did not specify"
		ewarn "via the VIDEO_CARDS variable what video card you use."
		ewarn "DirectFB supports: ${IUSE_VIDEO_CARDS} all none"
		echo
	fi
	if [[ -z ${INPUT_DEVICES} ]] ; then
		ewarn "All input drivers will be built since you did not specify"
		ewarn "via the INPUT_DEVICES variable which input drivers to use."
		ewarn "DirectFB supports: ${IUSE_INPUT_DEVICES} all none"
		echo
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${WORKDIR}"/${P}-upstream-git-gfxdrivers-fixes.patch
	epatch "${FILESDIR}"/${PN}-0.9.24-CFLAGS.patch
	epatch "${FILESDIR}"/${P}-headers.patch
	epatch "${FILESDIR}"/${P}-pkgconfig.patch
}

src_compile() {
	local vidcards card input inputdrivers
	for card in ${VIDEO_CARDS} ; do
		has ${card} ${IUSE_VIDEO_CARDS} && vidcards="${vidcards},${card}"
		#use video_cards_${card} && vidcards="${vidcards},${card}"
	done
	[[ -z ${vidcards} ]] \
		&& vidcards="all" \
		|| vidcards=${vidcards:1}
	for input in ${INPUT_DEVICES} ; do
		has ${input} ${IUSE_INPUT_DEVICES} && inputdrivers="${inputdrivers},${input}"
		#use input_devics_${input} && inputdrivers="${inputdrivers},${input}"
	done
	[[ -z ${inputdrivers} ]] \
		&& inputdrivers="all" \
		|| inputdrivers=${inputdrivers:1}

	local sdlconf="--disable-sdl"
	if use sdl ; then
		# since SDL can link against DirectFB and trigger a
		# dependency loop, only link against SDL if it isn't
		# broken #61592
		echo 'int main(){}' > sdl-test.c
		$(tc-getCC) sdl-test.c -lSDL 2>/dev/null \
			&& sdlconf="--enable-sdl" \
			|| ewarn "Disabling SDL since libSDL.so is broken"
	fi

	econf \
		--enable-static \
		$(use_enable fbcon fbdev) \
		$(use_enable mmx) \
		$(use_enable sse) \
		$(use_enable jpeg) \
		$(use_enable png) \
		$(use_enable gif) \
		$(use_enable truetype freetype) \
		$(use_enable fusion multi) \
		$(use_enable debug) \
		$(use_enable sysfs) \
		$(use_enable zlib) \
		$(use_enable v4l video4linux) \
		$(use_enable v4l2 video4linux2) \
		${sdlconf} \
		--with-gfxdrivers="${vidcards}" \
		--with-inputdrivers="${inputdrivers}" \
		--disable-vnc \
		|| die
	emake || die
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc fb.modes AUTHORS ChangeLog NEWS README* TODO
	dohtml -r docs/html/*
}

pkg_postinst() {
	ewarn "Each DirectFB update in the 0.9.xx series"
	ewarn "breaks DirectFB related applications."
	ewarn "Please run \"revdep-rebuild\" which can be"
	ewarn "found by emerging the package 'gentoolkit'."
	ewarn
	ewarn "If you have an ALPS touchpad, then you might"
	ewarn "get your mouse unexpectedly set in absolute"
	ewarn "mode in all DirectFB applications."
	ewarn "This can be fixed by removing linuxinput from"
	ewarn "INPUT_DEVICES."
}
