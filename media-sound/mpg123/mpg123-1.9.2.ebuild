# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/mpg123/mpg123-1.9.2.ebuild,v 1.8 2010/01/18 18:28:31 armin76 Exp $

EAPI=2
inherit eutils

DESCRIPTION="a realtime MPEG 1.0/2.0/2.5 audio player for layers 1, 2 and 3"
HOMEPAGE="http://www.mpg123.org"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2
	http://www.mpg123.org/download/${P}.tar.bz2"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sparc x86 ~x86-fbsd"
IUSE="3dnow 3dnowext alsa altivec ipv6 jack mmx nas +network oss portaudio pulseaudio sdl sse"

RDEPEND="alsa? ( media-libs/alsa-lib )
	jack? ( media-sound/jack-audio-connection-kit )
	nas? ( media-libs/nas )
	portaudio? ( media-libs/portaudio )
	pulseaudio? ( media-sound/pulseaudio )
	sdl? ( media-libs/libsdl )
	sys-devel/libtool"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}"/${P}-libtool.patch
}

src_configure() {
	local _audio=dummy
	local _output=dummy
	local _cpu=generic_fpu
	local _ipv6=disable

	for flag in nas portaudio sdl oss jack alsa pulseaudio; do
		if use ${flag}; then
			_audio="${_audio} ${flag/pulseaudio/pulse}"
			_output=${flag/pulseaudio/pulse}
		fi
	done

	use altivec && _cpu=altivec

	if [[ ${ABI} = amd64 ]] && use sse; then
		_cpu=x86-64
	fi

	if [[ ${ABI} = x86 ]]; then
		_cpu=i586
		use mmx && _cpu=mmx
		use 3dnow && _cpu=3dnow
		use sse && _cpu=x86
		use 3dnowext && _cpu=x86
	fi

	if use network && use ipv6; then
		_ipv6=enable
	fi

	econf \
		--disable-dependency-tracking \
		--with-optimization=0 \
		--with-audio="${_audio}" \
		--with-default-audio=${_output} \
		--with-cpu=${_cpu} \
		$(use_enable network) \
		--${_ipv6}-ipv6
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog NEWS* README
}
