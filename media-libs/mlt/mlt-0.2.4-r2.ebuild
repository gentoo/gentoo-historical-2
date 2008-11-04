# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/mlt/mlt-0.2.4-r2.ebuild,v 1.8 2008/11/04 19:07:29 aballier Exp $

EAPI=1

inherit eutils toolchain-funcs qt3

DESCRIPTION="MLT is an open source multimedia framework, designed and developed
for television broadcasting"
HOMEPAGE="http://mlt.sourceforge.net/"
SRC_URI="mirror://sourceforge/mlt/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="dv xml jack gtk sdl vorbis sox quicktime mmx lame xine lame ogg theora
xine ffmpeg libsamplerate qt3"

DEPEND="ffmpeg? ( >=media-video/ffmpeg-0.4.9_p20070616-r3
		<media-video/ffmpeg-0.4.9_p20081014 )
	dv?	( >=media-libs/libdv-0.104 )
	xml?	( >=dev-libs/libxml2-2.5 )
	ogg?	( >=media-libs/libogg-1.1.3 )
	vorbis?	( >=media-libs/libvorbis-1.1.2 )
	sdl?	( >=media-libs/libsdl-1.2.10
		  >=media-libs/sdl-image-1.2.4 )
	libsamplerate? ( >=media-libs/libsamplerate-0.1.2 )
	jack?	( media-sound/jack-audio-connection-kit
			  media-libs/ladspa-sdk
			  >=dev-libs/libxml2-2.5 )
	gtk?	( >=x11-libs/gtk+-2
		  x11-libs/pango )
	sox? ( media-sound/sox )
	quicktime? ( media-libs/libquicktime )
	xine? ( >=media-libs/xine-lib-1.1.2_pre20060328-r7 )
	lame? ( >=media-sound/lame-3.97_beta2 )
	qt3? ( x11-libs/qt:3 )
	theora? ( >=media-libs/libtheora-1.0_alpha5 )"
RDEPEND=${DEPEND}

pkg_setup() {
	local fail="USE sox needs also USE libsamplerate enabled."

	if use sox && ! use libsamplerate; then
		eerror "${fail}"
		die "${fail}"
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/mlt-0.2.2-motion-est-nonx86.patch
	epatch "${FILESDIR}"/mlt-0.2.3-nostrip.patch
	epatch "${FILESDIR}"/${P}-sox1400.patch
	epatch "${FILESDIR}"/${P}-ffmpegheaders.patch
	epatch "${FILESDIR}"/${P}-avdevice.patch
	epatch "${FILESDIR}"/${P}-bashism.patch
	epatch "${FILESDIR}"/${P}-double-fps.patch
	epatch "${FILESDIR}"/${P}-gcc-4.3.patch
	epatch "${FILESDIR}"/${P}-avfreestatic.patch
	epatch "${FILESDIR}"/${P}-sox1410.patch
}

src_compile() {
	tc-export CC

	local myconf="	--enable-gpl --enable-shared
			--enable-pp --enable-shared-pp
			--enable-motion-est
			$(use_enable dv)
			$(use_enable mmx)
			$(use_enable gtk gtk2)
			$(use_enable vorbis)
			$(use_enable ogg)
			$(use_enable sdl)
			$(use_enable jack jackrack)
			$(use_enable sox)
			$(use_enable theora)
			$(use_enable lame mp3lame)
			$(use_enable ffmpeg avformat)
			$(use_enable libsamplerate resample)
			$(use_enable qt3 qimage)
			$(use_enable xml westley)
			$(use_enable xine)"

	use ffmpeg && has_version ">=media-video/ffmpeg-0.4.9_p20070616-r20" &&
		myconf="${myconf} --avformat-swscale"

	(use quicktime && use dv) ||  myconf="${myconf} --disable-kino"

	econf ${myconf} || die "econf failed"
	sed -i -e s/^OPT/#OPT/ "${S}/config.mak"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	dodoc docs/*.txt ChangeLog README docs/TODO

	dodir /usr/share/${PN}
	insinto /usr/share/${PN}
	doins -r demo
}
