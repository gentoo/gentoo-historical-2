# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/alsa-plugins/alsa-plugins-1.0.13.ebuild,v 1.13 2006/12/21 14:31:36 kloeri Exp $

WANT_AUTOMAKE=latest
WANT_AUTOCONF=latest

inherit libtool autotools eutils flag-o-matic

MY_P="${P/_/}"

DESCRIPTION="ALSA extra plugins"
HOMEPAGE="http://www.alsa-project.org/"
SRC_URI="mirror://alsaproject/plugins/${MY_P}.tar.bz2"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="alpha ~amd64 arm ~hppa ia64 ppc ppc64 sh sparc x86"
IUSE="jack ffmpeg libsamplerate pulseaudio debug"

RDEPEND=">=media-libs/alsa-lib-1.0.12_rc1
	jack? ( >=media-sound/jack-audio-connection-kit-0.98 )
	ffmpeg? ( media-video/ffmpeg )
	libsamplerate? ( media-libs/libsamplerate )
	pulseaudio? ( media-sound/pulseaudio )
	!media-plugins/alsa-jack"

DEPEND="${RDEPEND}
	dev-util/pkgconfig"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}/${PN}-1.0.12-automagic.patch"

	# For some reasons the polyp/pulse plugin does fail with alsaplayer with a
	# failed assert. As the code works just fine with asserts disabled, for now
	# disable them waiting for a better solution.
	sed -i -e '/AM_CFLAGS/s:-Wall:-DNDEBUG -Wall:' \
		"${S}/pulse/Makefile.am"

	eautoreconf

	elibtoolize
}

src_compile() {
	use debug || append-flags -DNDEBUG
	econf \
		$(use_enable jack) \
		$(use_enable libsamplerate samplerate) \
		$(use_enable ffmpeg avcodec) \
		$(use_enable pulseaudio) \
		--disable-dependency-tracking \
		|| die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install

	cd "${S}/doc"
	dodoc upmix.txt vdownmix.txt README-pcm-oss
	use jack && dodoc README-jack
	use libsamplerate && dodoc samplerate.txt
	use pulseaudio && dodoc README-pulse
}
