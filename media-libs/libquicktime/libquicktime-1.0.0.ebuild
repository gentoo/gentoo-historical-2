# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libquicktime/libquicktime-1.0.0.ebuild,v 1.4 2007/09/23 11:27:34 drac Exp $

WANT_AUTOMAKE="latest"
WANT_AUTOCONF="latest"
inherit libtool eutils autotools

DESCRIPTION="A library based on quicktime4linux with extensions"
HOMEPAGE="http://libquicktime.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"

IUSE="mmx X opengl dv gtk alsa aac encode png jpeg vorbis lame x264 ffmpeg"

RDEPEND="dv? ( media-libs/libdv )
	gtk? ( >=x11-libs/gtk+-2.4.0 )
	aac? (
		media-libs/faad2
		encode? ( media-libs/faac )
	)
	alsa? ( media-libs/alsa-lib )
	png? ( media-libs/libpng )
	jpeg? ( media-libs/jpeg )
	vorbis? ( media-libs/libvorbis media-libs/libogg )
	lame? ( media-sound/lame )
	ffmpeg? ( media-video/ffmpeg )
	x264? ( >=media-libs/x264-svn-20060810 )
	X? ( x11-libs/libXaw
		x11-libs/libXv
		x11-libs/libXext
		x11-libs/libX11
		opengl? ( media-libs/mesa )
	)
	!virtual/quicktime"
DEPEND="${RDEPEND}
	X? (
		x11-proto/videoproto
		x11-proto/xextproto
	)
	dev-util/pkgconfig"

PROVIDE="virtual/quicktime"

pkg_setup() {
	if has_version '=x11-base/xorg-x11-6*' && ! built_with_use x11-base/xorg-x11 xv; then
		die "You need xv support to compile ${PN}."
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-cflags.patch
	epatch "${FILESDIR}"/${P}-gtk212.patch
	AT_M4DIR="m4" eautoreconf
}

src_compile() {
	local MY_OPTS=""
	if use !encode || use !aac; then
		MY_OPTS="--without-faac"
	fi

	econf --enable-shared \
		--enable-static \
		--enable-gpl \
		$(use_enable mmx) \
		$(use_with X x) \
		$(use_with gtk) \
		$(use_with dv libdv) \
		$(use_with alsa) \
		$(use_with aac faad2) \
		$(use_with png libpng) \
		$(use_with jpeg libjpeg) \
		$(use vorbis || echo "--without-vorbis") \
		$(use_with lame) \
		$(use_with x264) \
		$(use_with ffmpeg) \
		$(use_with opengl) \
		${MY_OPTS} \
		--without-cpuflags || die "econf failed"

	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	# Compatibility with software that uses quicktime prefix, but
	# don't do that when building for Darwin/MacOS
	[[ ${CHOST} != *-darwin* ]] && \
	dosym /usr/include/lqt /usr/include/quicktime
}

pkg_preinst() {
	if [[ -d /usr/include/quicktime && ! -L /usr/include/quicktime ]]; then
		elog "For compatibility with other quicktime libraries, ${PN} was"
		elog "going to create a /usr/include/quicktime symlink, but for some"
		elog "reason that is a directory on your system."

		if $(has_version =media-libs/libquicktime-0.9.4); then
			elog "It seems this directory belongs to libquicktime-0.9.4."
			elog "We'll delete that directory now."
			rm -rvf /usr/include/quicktime
		else
			elog "Please check that is empty, and remove it, or submit a bug"
			elog "telling us which package owns the directory."
			die "/usr/include/quicktime is a directory."
		fi
	fi
}
