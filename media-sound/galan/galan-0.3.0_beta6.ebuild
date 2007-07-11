# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/galan/galan-0.3.0_beta6.ebuild,v 1.7 2007/07/11 19:30:24 mr_bones_ Exp $

IUSE="vorbis alsa opengl esd jack"

DESCRIPTION="gAlan - Graphical Audio Language"
HOMEPAGE="http://galan.sourceforge.net/"
SRC_URI="mirror://sourceforge/galan/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"

KEYWORDS="~amd64 ~ppc ~sparc ~x86"

DEPEND=">=x11-libs/gtk+-2.0
	vorbis? ( >=media-sound/vorbis-tools-1.0 )
	alsa? ( >=media-libs/alsa-lib-0.9.0_rc1 )
	opengl? ( >=x11-libs/gtkglarea-1.99.0 )
	esd? ( media-sound/esound )
	jack? ( >=media-sound/jack-audio-connection-kit-0.80.0 )
	media-libs/liblrdf
	media-libs/ladspa-sdk
	media-libs/audiofile
	media-libs/libsndfile
	=sci-libs/fftw-2*"

src_install() {
	make DESTDIR="${D}" install || die "install failed"
	dodoc AUTHORS ChangeLog NEWS README TODO doc/
}
