# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/freqtweak/freqtweak-0.5.2.ebuild,v 1.1 2003/09/16 14:46:46 tigger Exp $

DESCRIPTION="tool for FFT-based realtime audio spectral manipulation and display"
HOMEPAGE="http://freqtweak.sourceforge.net"
SRC_URI="mirror://sourceforge//freqtweak/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"

DEPEND="x11-libs/wxGTK
	dev-libs/fftw
	virtual/jack"

src_compile() {
	econf || die
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
}
