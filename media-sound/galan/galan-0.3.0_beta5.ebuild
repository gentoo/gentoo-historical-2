# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/galan/galan-0.3.0_beta5.ebuild,v 1.4 2004/04/17 18:21:48 eradicator Exp $

DESCRIPTION="gAlan - Graphical Audio Language"
HOMEPAGE="http://galan.sourceforge.net/"
SRC_URI="mirror://sourceforge/galan/${P}.tar.gz"
RESTRICT="nomirror"

SLOT="0"
LICENSE="GPL-2"

KEYWORDS="~x86 ~ppc"

IUSE="oggvorbis alsa opengl esd jack"

DEPEND=">=x11-libs/gtk+-2.0
	oggvorbis? ( >=media-sound/vorbis-tools-1.0 )
	alsa? ( >=media-libs/alsa-lib-0.9.0_rc1 )
	opengl? ( >=x11-libs/gtkglarea-1.99.0 )
	esd? ( media-sound/esound )
	jack? ( >=media-sound/jack-audio-connection-kit-0.80.0 )
	media-libs/liblrdf
	media-libs/ladspa-sdk
	media-libs/audiofile
	media-libs/libsndfile
	=dev-libs/fftw-2*"

DOC="AUTHORS COPYING ChangeLog INSTALL NEWS README TODO doc/"

src_install() {
	make DESTDIR=${D} install || die "install failed"
	dodoc ${DOC}
}

