# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/freqtweak/freqtweak-0.5.2.ebuild,v 1.5 2004/06/25 00:00:15 agriffis Exp $

DESCRIPTION="tool for FFT-based realtime audio spectral manipulation and display"
HOMEPAGE="http://freqtweak.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
RESTRICT="nomirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"

IUSE=""

DEPEND="x11-libs/wxGTK
	dev-libs/fftw
	media-sound/jack-audio-connection-kit"

pkg_setup() {
	if wx-config --cppflags | grep gtk2u >& /dev/null; then
		einfo "${PN} will not build if wxGTK was compiled"
		einfo "with unicode support.  If you are using a version of"
		einfo "wxGTK <= 2.4.2, you must set USE=-gtk2.  In newer versions,"
		einfo "you must set USE=-unicode."
		die "wxGTK must be re-emerged without unicode suport"
	fi
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc AUTHORS COPYING ChangeLog NEWS README THANKS
}
