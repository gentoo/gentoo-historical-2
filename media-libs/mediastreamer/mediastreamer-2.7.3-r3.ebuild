# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/mediastreamer/mediastreamer-2.7.3-r3.ebuild,v 1.2 2011/04/30 17:38:31 pva Exp $

EAPI="4"

inherit eutils autotools multilib

DESCRIPTION="Mediastreaming library for telephony application"
HOMEPAGE="http://www.linphone.org/"
SRC_URI="mirror://nongnu/linphone/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
# Many cameras will not work or will crash an application if mediastreamer2 is
# not built with v4l2 support (taken from configure.ac)
# TODO: run-time test for ipv6: does it really need ortp[ipv6] ?
IUSE="+alsa amr bindist coreaudio debug examples gsm ilbc ipv6 jack oss portaudio
pulseaudio sdl +speex theora v4l2 video x264 X xv"
REQUIRED_USE="|| ( oss alsa jack portaudio coreaudio )
	video? ( || ( sdl X ) )
	theora? ( video )
	X? ( video )
	xv? ( X )
	v4l2? ( video )"

RDEPEND=">=net-libs/ortp-0.16.2[ipv6?]
	alsa? ( media-libs/alsa-lib )
	gsm? ( media-sound/gsm )
	jack? ( >=media-libs/libsamplerate-0.0.13
		media-sound/jack-audio-connection-kit )
	portaudio? ( media-libs/portaudio )
	pulseaudio? ( >=media-sound/pulseaudio-0.9.21 )
	speex? ( >=media-libs/speex-1.2_beta3 )
	video? (
		virtual/ffmpeg
		v4l2? ( media-libs/libv4l
			sys-kernel/linux-headers )
		theora? ( media-libs/libtheora )
		sdl? ( media-libs/libsdl[video,X] )
		X? ( x11-libs/libX11
			xv? ( x11-libs/libXv ) ) )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	xv? ( x11-proto/videoproto )"

PDEPEND="amr? ( !bindist? ( media-plugins/mediastreamer-amr ) )
	ilbc? ( media-plugins/mediastreamer-ilbc )
	video? ( x264? ( media-plugins/mediastreamer-x264 ) )"

src_prepare() {
	# respect user's CFLAGS
	sed -i -e "s:-O2::;s: -g::" configure.ac || die "patching configure.ac failed"

	# change default paths
	sed -i -e "s:\(\${prefix}/\)lib:\1$(get_libdir):" \
		-e "s:\(prefix/share\):\1/${PN}:" configure.ac \
		|| die "patching configure.ac failed"

	# fix html doc installation dir
	sed -i -e "s:\$(pkgdocdir):\$(docdir):" help/Makefile.am \
		|| die "patching help/Makefile.am failed"
	sed -i -e "s:\(doc_htmldir=\).*:\1\$(htmldir):" help/Makefile.am \
		|| die "patching help/Makefile.am failed"

	epatch "${FILESDIR}/${PN}-2.7.3-v4l-automagic.patch"
	epatch "${FILESDIR}/${P}-sdl-build.patch"

	# linux/videodev.h dropped in 2.6.38
	sed -i -e 's:msv4l.c::' src/Makefile.am || die
	sed -i -e 's:linux/videodev.h ::' configure.ac || die
	eautoreconf

	# don't build examples in tests/
	sed -i -e "s:\(SUBDIRS = .*\) tests \(.*\):\1 \2:" Makefile.in \
		|| die "patching Makefile.in failed"
}

src_configure() {
	# Mac OS X Audio Queue is an audio recording facility, available on
	# 10.5 (Leopard, Darwin9) and onward
	local macaqsnd="--disable-macaqsnd"
	if use coreaudio && [[ ${CHOST} == *-darwin* && ${CHOST##*-darwin} -ge 9 ]];
	then
		macaqsnd="--enable-macaqsnd"
	fi

	# strict: don't want -Werror
	# external-ortp: don't use bundled libs
	# arts: arts is deprecated
	econf \
		--htmldir="${EPREFIX}"/usr/share/doc/${PF}/html \
		--datadir="${EPREFIX}"/usr/share/${PN} \
		--libdir="${EPREFIX}"/usr/$(get_libdir) \
		--disable-strict \
		--enable-external-ortp \
		--disable-artsc \
		$(use_enable alsa) \
		$(use_enable pulseaudio) \
		$(use_enable coreaudio macsnd) ${macaqsnd} \
		$(use_enable debug) \
		$(use_enable gsm) \
		$(use_enable ipv6) \
		$(use_enable jack) \
		$(use_enable oss) \
		$(use_enable portaudio) \
		$(use_enable speex) \
		$(use_enable theora) \
		$(use_enable video) \
		$(use_enable v4l2 v4l) \
		$(use_enable v4l2 libv4l) \
		$(use_enable sdl) \
		$(use_enable X x11) \
		$(use_enable xv)
}

src_install() {
	emake DESTDIR="${D}" install

	dodoc AUTHORS ChangeLog NEWS README

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins tests/*.c
	fi
}
