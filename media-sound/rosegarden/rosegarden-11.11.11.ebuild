# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/rosegarden/rosegarden-11.11.11.ebuild,v 1.2 2012/03/28 06:56:15 ago Exp $

EAPI=4
inherit autotools fdo-mime gnome2-utils multilib

DESCRIPTION="MIDI and audio sequencer and notation editor"
HOMEPAGE="http://www.rosegardenmusic.com/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~x86"
IUSE="debug lirc"

RDEPEND="x11-libs/qt-gui:4
	media-libs/ladspa-sdk
	x11-libs/libSM
	media-sound/jack-audio-connection-kit
	media-libs/alsa-lib
	>=media-libs/dssi-1.0.0
	media-libs/liblo
	media-libs/liblrdf
	sci-libs/fftw:3.0
	media-libs/libsamplerate[sndfile]
	lirc? ( app-misc/lirc )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	x11-misc/makedepend"

src_prepare() {
	if ! use lirc; then
		sed -i \
			-e '/AC_CHECK_HEADER/s:lirc_client.h:dIsAbLe&:' \
			-e '/AC_CHECK_LIB/s:lirc_init:dIsAbLe&:' \
			configure.ac || die
	fi

	eautoreconf
}

src_configure() {
	export USER_CXXFLAGS="${CXXFLAGS}"

	local myconf
	use debug && myconf="--enable-debug"

	econf \
		--with-qtdir=/usr \
		--with-qtlibdir=/usr/$(get_libdir)/qt4 \
		${myconf}
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
}

pkg_postrm() {
	gnome2_icon_cache_update
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
}
