# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/alsa-plugins/alsa-plugins-1.0.12_rc1-r1.ebuild,v 1.1 2006/07/17 11:23:32 flameeyes Exp $

inherit libtool autotools eutils flag-o-matic

MY_P="${P/_/}"

DESCRIPTION="ALSA extra plugins"
HOMEPAGE="http://www.alsa-project.org/"
SRC_URI="mirror://alsaproject/plugins/${MY_P}.tar.bz2"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"
IUSE="jack ffmpeg libsamplerate pulseaudio debug"

# It could support polypaudio if it was in portage
RDEPEND=">=media-libs/alsa-lib-1.0.11
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

	epatch "${FILESDIR}/${P}-automagic.patch"

	# PolypAudio is now renamed PulseAudio. The former was never added in portage,
	# so just take care of the latter, by replacing the pkg-config module name
	# and the name of the resulting plugin.
	sed -i -e 's:polyplib:libpulse:' "${S}/configure.in"
	sed -i -e 's:polyp/polypaudio.h:pulse/pulseaudio.h:' \
		"${S}/polyp/polyp.h"
	# For some reasons the polyp/pulse plugin does fail with alsaplayer with a
	# failed assert. As the code works just fine with asserts disabled, for now
	# disable them waiting for a better solution.
	sed -i -e '/AM_CFLAGS/s:-Wall:-DNDEBUG -Wall:' \
		"${S}/polyp/Makefile.am"

	eautoreconf

	elibtoolize
}

src_compile() {
	use debug || append-flags -DNDEBUG
	econf \
		$(use_enable jack) \
		$(use_enable libsamplerate samplerate) \
		$(use_enable ffmpeg avcodec) \
		$(use_enable pulseaudio polypaudio) \
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
	use pulseaudio && dodoc README-polyp
}

pkg_postinst() {
	if use pulseaudio; then
		elog "This version of alsa-plugins does not support PulseAudio under this name."
		elog "as it was developed when it was called PolypAudio."
		elog "For this reason all the documentation refers to PolypAudio and"
		elog "the plugin is called polyp."
		elog "This situation is going to be solved in next release."
	fi
}