# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/e-uae/e-uae-0.8.29_pre20061116-r1.ebuild,v 1.2 2007/02/16 06:56:50 pva Exp $

inherit eutils flag-o-matic

my_ver=${PV%%_pre*}
snap_ver=${PV##*_pre}

DESCRIPTION="The Ubiquitous Amiga Emulator with an emulation core largely based on WinUAE"
HOMEPAGE="http://www.rcdrummond.net/uae/"
#SRC_URI="http://www.rcdrummond.net/uae/${P}/${P}.tar.bz2"
SRC_URI="mirror://gentoo/${PN}-${my_ver}-CVS-${snap_ver}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="X dga ncurses sdl gtk alsa oss sdl-sound capslib"

# Note: opposed to ./configure --help zlib support required! Check
# src/Makefile.am that includes zfile.c unconditionaly.
RDEPEND="X? ( || ( ( x11-libs/libXt
					 x11-libs/libxkbfile
					 x11-libs/libXext
					 dga? ( x11-libs/libXxf86dga
						    x11-libs/libXxf86vm )
				   )
				   virtual/x11
				)
			)
		!X? ( sdl? ( media-libs/libsdl )
			  !sdl? ( sys-libs/ncurses ) )
		alsa? ( media-libs/alsa-lib )
		!alsa? ( sdl-sound? ( media-libs/sdl-sound ) )
		gtk? ( >=x11-libs/gtk+-2.0 )
		capslib? ( >=games-emulation/caps-20060612 )
		sys-libs/zlib
		virtual/cdrtools"

DEPEND="$RDEPEND
		X? ( dga? ( x11-proto/xf86vidmodeproto
					x11-proto/xf86dgaproto ) )"

S="${WORKDIR}"/${PN}-${my_ver}-CVS

pkg_setup() {
	# Sound setup.
	if use alsa; then
		elog "Choosing alsa as sound target to use."
		myconf="--with-alsa --without-sdl-sound"
	elif use sdl-sound ; then
		if ! use sdl ; then
			ewarn "sdl-sound is not enabled because sdl USE flag is disabled. Leaving"
			ewarn "sound on oss autodetection."
			myconf="--without-alsa --without-sdl-sound"
			ebeep
		else
			elog "Choosing sdl-sound as sound target to use."
			ewarn "E-UAE with the SDL audio back-end doesn't work correctly in Linux."
			ewarn "Better use alsa... You've been warned ;)"
			ebeep
			myconf="--without-alsa --with-sdl-sound"
		fi
	elif use oss ; then
		elog "Choosing oss as sound target to use."
		ewarn "oss will be autodetected. See output of configure."
		myconf="--without-alsa --without-sdl-sound"
	else
		ewarn "There is no alsa, sdl-sound or oss in USE. Sound target disabled!"
		myconf="--disable-audio"
	fi

	# VIDEO setup. X is autodetected (there is no --with-X option).
	if use X ; then
		elog "Using X11 for video output."
		ewarn "Fullscreen mode is not working in X11 currently. Use sdl."
		myconf="$myconf --without-curses --without-sdl-gfx"
		use dga && ewarn "To use dga you have to run e-uae as root."
		use dga && myconf="$myconf --enable-dga --enable-vidmode"
	elif use sdl ; then
		elog "Using sdl for video output."
		myconf="$myconf --with-sdl --with-sdl-gfx --without-curses"
	elif use ncurses; then
		elog "Using ncurses for video output."
		myconf="$myconf --with-curses --without-sdl-gfx"
	else
		ewarn "There is no X or sdl or ncurses in USE!"
		ewarn "Following upstream falling back on ncurses."
		myconf="$myconf --with-curses --without-sdl-gfx"
		ebeep
	fi

	use gtk && myconf="$myconf --enable-ui --enable-threads"
	use gtk || myconf="$myconf --disable-ui"

	myconf="$myconf $(use_with capslib caps)"

	myconf="$myconf --with-zlib"

	# And explicitly state defaults:
	myconf="$myconf --enable-aga"
	myconf="$myconf --enable-autoconfig --enable-scsi-device --enable-cdtv --enable-cd32"
	myconf="$myconf --enable-bsdsock"
}

src_compile() {
	strip-flags

	econf ${myconf} \
		--with-libscg-includedir=/usr/include/scsilib \
		|| die "./configure failed"

	emake -j1 || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"

	# Rename it to e-uae
	mv "${D}/usr/bin/uae" "${D}/usr/bin/${PN}"
	mv "${D}/usr/bin/readdisk" "${D}/usr/bin/e-readdisk"

	dodoc docs/* README ChangeLog
}
