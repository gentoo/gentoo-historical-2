# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/mjpegtools/mjpegtools-1.6.1.91.ebuild,v 1.4 2004/01/15 01:52:38 vapier Exp $

inherit flag-o-matic gcc

DESCRIPTION="Tools for MJPEG video."
HOMEPAGE="http://mjpeg.sourceforge.net/"
SRC_URI="mirror://sourceforge/mjpeg/${P}.tar.gz"
RESTRICT="nomirror"

LICENSE="as-is"
SLOT="1"
KEYWORDS="~x86 -ppc"
IUSE="gtk avi dv quicktime sdl X 3dnow mmx sse"

DEPEND="media-libs/jpeg
	>=sys-apps/sed-4
	=dev-libs/glib-1.2*
	x86? ( media-libs/libmovtar
		mmx? ( >=media-libs/jpeg-mmx-1.1.2-r1 dev-lang/nasm )
		3dnow? ( dev-lang/nasm )
		sse? ( dev-lang/nasm )
	)
	gtk? ( =x11-libs/gtk+-1.2* )
	avi? ( >=media-video/avifile-0.7.38 )
	dv? ( >=media-libs/libdv-0.99 )
	quicktime? ( virtual/quicktime )
	sdl? ( media-libs/libsdl )
	X? ( x11-base/xfree )"

src_unpack() {
	unpack ${A} ; cd ${S}

	epatch ${FILESDIR}/${P}-fPIC.patch
#	epatch "${FILESDIR}/no-x11-lib.patch"
}

src_compile() {
	local myconf

	[ `gcc-major-version` -eq 3 ] && append-flags -mno-sse2

	myconf="${myconf} `use_with X x`"
	myconf="${myconf} `use_with quicktime`"
	myconf="${myconf} `use_enable x86 cmov-extensions`"

	if [ "`use dv`" ] ; then
		myconf="${myconf} --with-dv=/usr"
	fi

	if [ "`use x86`" ]; then
		if [ "`use mmx`" -o "`use 3dnow`" -o "`use sse`" ] ; then
			myconf="${myconf} --enable-simd-accel"
		fi
		if [ "`use mmx`" ] ; then
			myconf="${myconf} --with-jpeg-mmx=/usr/include/jpeg-mmx"
		fi
	fi

	econf ${myconf}

	if has_version 'sys-devel/hardened-gcc' ; then
		for i in `find "${S}" -name "Makefile"` ; do
			sed -e "s:CC = gcc:CC = gcc -yet_exec:g" \
				-e "s:CXX = gcc:CXX = g++ -yet_exec:g" \
				-e "s:CXXCPP = gcc -E:CXX = g++ -E -yet_exec:g" \
				-i "${i}" || die "sed failed"
		done
	fi

	emake -j1 || die "compile problem"
}

src_install() {
	einstall
	dodoc mjpeg_howto.txt
}
