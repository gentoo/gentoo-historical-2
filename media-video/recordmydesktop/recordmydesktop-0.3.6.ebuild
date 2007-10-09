# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/recordmydesktop/recordmydesktop-0.3.6.ebuild,v 1.1 2007/10/09 18:32:07 aballier Exp $

inherit eutils

DESCRIPTION="A desktop session recorder producing Ogg video/audio files"
HOMEPAGE="http://recordmydesktop.iovar.org/"
SRC_URI="mirror://sourceforge/recordmydesktop/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="jack alsa"

DEPEND="x11-libs/libXext
	x11-libs/libXdamage
	x11-libs/libXfixes
	x11-libs/libICE
	x11-libs/libSM
	media-libs/libogg
	media-libs/libvorbis
	media-libs/libtheora
	alsa? ( media-libs/alsa-lib )
	jack? ( media-sound/jack-audio-connection-kit )"

pkg_setup() {
	if ! built_with_use media-libs/libtheora encode; then
		eerror "media-libs/libtheora needs to be built with encode use flag"
		eerror "in order to use ${PN}"
		die "Please rebuild  media-libs/libtheora with encode use flag"
	fi
}

src_compile() {
	econf $(use_enable jack) $(use_enable !alsa oss) || die "configure failed"
	emake || die "make failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc NEWS README AUTHORS ChangeLog
}
