# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/e-uae/e-uae-0.8.27.ebuild,v 1.3 2005/06/15 11:12:45 dholm Exp $

inherit eutils flag-o-matic

DESCRIPTION="The Eggplant Umiquious Amiga Emulator"
HOMEPAGE="http://www.rcdrummond.net/uae/"
SRC_URI="http://www.rcdrummond.net/uae/${P}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc ~x86"
IUSE="X gtk sdl ncurses svga"

DEPEND="virtual/libc
	X? (
		virtual/x11
		gtk? ( >=x11-libs/gtk+-2.0.0 )
	)
	!X? (
		ncurses? ( sys-libs/ncurses )
		svga? ( media-libs/svgalib )
	)
	sdl? ( media-libs/libsdl )
	app-cdr/cdrtools
	games-emulation/caps"

src_compile() {
	# -O3 breaks compilation, GCC will eat all your RAM + Swap and die
	replace-flags "-O3" "-O2"
	use x86 && strip-flags "-msse" "-msse2"
	use ppc && strip-flags "-maltivec" "-mabi=altivec"
	use sdl && myconf="--with-sdl-sound --with-sdl-gfx"

	export WANT_AUTOMAKE=1.7
	export WANT_AUTOCONF=2.5
	./bootstrap.sh || die "bootstrap failed"
	econf ${myconf} \
		--enable-threads \
		--enable-cdtv \
		--enable-cd32 \
		--enable-scsi-device \
		--enable-bsdsock \
		--with-libscg-includedir=/usr/include/scsilib \
		|| die "./configure failed"

	emake -j1 || die "emake failed"
}

src_install() {
	dodoc docs/*
	dodoc README COPYING ChangeLog CHANGES

	emake install DESTDIR=${D}

	insinto /usr/share/uae/amiga-tools
	doins amiga/{*hack,trans*,uae*,*.library}

	# Rename it to e-uae
	mv ${D}/usr/bin/uae ${D}/usr/bin/e-uae
	mv ${D}/usr/bin/readdisk ${D}/usr/bin/e-readdisk
	mv ${D}/usr/share/uae ${D}/usr/share/${PN}
}
