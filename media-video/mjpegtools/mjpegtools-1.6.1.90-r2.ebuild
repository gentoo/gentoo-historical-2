# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/mjpegtools/mjpegtools-1.6.1.90-r2.ebuild,v 1.9 2005/01/11 12:16:52 lu_zero Exp $

inherit flag-o-matic gcc eutils

DESCRIPTION="Tools for MJPEG video."
HOMEPAGE="http://mjpeg.sourceforge.net/"
SRC_URI="mirror://sourceforge/mjpeg/${P}.tar.gz"

LICENSE="as-is"
SLOT="1"
KEYWORDS="x86 -ppc ~sparc"
IUSE="gtk avi dv quicktime sdl X 3dnow mmx sse"

DEPEND="media-libs/jpeg
	>=sys-apps/sed-4
	=dev-libs/glib-1.2*
	x86? ( media-libs/libmovtar
	       sse? ( dev-lang/nasm )
	       mmx? ( >=media-libs/jpeg-mmx-1.1.2-r1 dev-lang/nasm )
	       3dnow? ( dev-lang/nasm ) )
	gtk? ( =x11-libs/gtk+-1.2* )
	avi? ( >=media-video/avifile-0.7.38 )
	dv? ( >=media-libs/libdv-0.99 )
	quicktime? ( virtual/quicktime )
	sdl? ( media-libs/libsdl )
	X? ( virtual/x11 )"

src_unpack() {
	unpack ${A} && cd "${S}"
	use X || epatch "${FILESDIR}/no-x11-lib.patch"
}

src_compile() {
	local myconf

	filter-flags -fPIC

	use x86 && [ $(gcc-major-version) -eq 3 ] && append-flags -mno-sse2

	myconf="${myconf} $(use_with X x)"
	myconf="${myconf} $(use_with quicktime)"
	myconf="${myconf} $(use_enable x86 cmov-extensions)"

	if use dv ; then
		myconf="${myconf} --with-dv=/usr"
	fi
	if use mmx || use 3dnow || use sse; then
		myconf="${myconf} --enable-simd-accel"
	fi
	if use mmx ; then
		myconf="${myconf} --with-jpeg-mmx=/usr/include/jpeg-mmx"
	fi

	econf ${myconf} || die "econf failed"

	emake || die "compile problem"

	cd docs
	local infofile
	for infofile in mjpeg*info*; do
		echo "INFO-DIR-SECTION Miscellaneous" >> ${infofile}
		echo "START-INFO-DIR-ENTRY" >> ${infofile}
		echo "* mjpeg-howto: (mjpeg-howto).                  How to use the mjpeg-tools" >> ${infofile}
		echo "END-INFO-DIR-ENTRY" >> ${infofile}
	done
}

src_install() {
	einstall
	dodoc mjpeg_howto.txt
}
