# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/fluidsynth/fluidsynth-1.0.8.ebuild,v 1.6 2009/08/01 06:27:08 ssuominen Exp $

inherit flag-o-matic eutils libtool

IUSE="alsa debug jack ladspa lash oss readline"

DESCRIPTION="Fluidsynth is a software real-time synthesizer based on the Soundfont 2 specifications."
HOMEPAGE="http://www.fluidsynth.org/"
SRC_URI="http://savannah.nongnu.org/download/fluid/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ppc ppc64 sparc x86 ~x86-fbsd"

DEPEND="jack? ( media-sound/jack-audio-connection-kit )
	ladspa? ( >=media-libs/ladspa-sdk-1.12
			  >=media-libs/ladspa-cmt-1.15 )
	alsa? ( media-libs/alsa-lib
			lash? ( >=media-sound/lash-0.5 ) )
	readline? ( sys-libs/readline )"

S="${WORKDIR}/${P/7a/7}"

# Alsa is required for lash support in this package.
pkg_setup() {
	if use lash && ! use alsa; then
		ewarn "ALSA support is required for lash support to be enabled."
		ewarn "Continuing with lash support disabled."
	fi
}

src_compile() {
	local myconf

	if use alsa; then
		myconf="${myconf} $(use_enable lash)"
	else
		myconf="--disable-lash"
	fi

	elibtoolize
	# ladcca support is deprecated in place of lash
	econf \
		--disable-ladcca \
		--disable-dependency-tracking \
		$(use_enable ladspa) \
		$(use_enable jack jack-support) \
		$(use_enable oss oss-support) \
		$(use_enable alsa alsa-support) \
		$(use_enable lash) \
		$(use_enable debug) \
		$(use_with readline) \
		${myconf} || die "./configure failed"

	emake || die "make failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS NEWS README THANKS TODO
}
