# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/mhwaveedit/mhwaveedit-1.4.5b.ebuild,v 1.5 2006/01/18 14:28:49 metalgod Exp $

IUSE="alsa arts esd jack ladspa libsamplerate nls oss portaudio sdl sndfile sox"

DESCRIPTION="GTK2 Sound file editor (wav, and a few others.)"
HOMEPAGE="https://gna.org/projects/mhwaveedit/"
SRC_URI="http://download.gna.org/mhwaveedit/${P}.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ~ppc sparc x86"

DEPEND=">=x11-libs/gtk+-2
	sndfiile? ( >=media-libs/libsndfile-1.0.10 )
	sdl? ( >=media-libs/libsdl-1.2.3 )
	alsa? ( media-libs/alsa-lib )
	arts? ( >=kde-base/arts-3.4.1 )
	portaudio? ( >=media-libs/portaudio-18 )
	jack? ( >=media-sound/jack-audio-connection-kit-0.98.0 )
	esd? ( >=media-sound/esound-0.2.0 )
	libsamplerate? ( media-libs/libsamplerate )
	ladspa? ( media-libs/ladspa-sdk )
	sox? ( media-sound/sox )"

src_compile() {
	econf \
		$(use_enable nls) \
		$(use_with sndfile libsndfile) \
		$(use_with libsamplerate) \
		$(use_with portaudio) \
		$(use_with sdl) \
		$(use_with alsa alsalib) \
		$(use_with oss) \
		$(use_with jack) \
		$(use_with esd esound) \
		$(use_with arts) || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die

	dodoc AUTHORS BUGS ChangeLog NEWS README TODO
}
