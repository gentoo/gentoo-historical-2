# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/freqtweak/freqtweak-0.7.0_pre20070214.ebuild,v 1.1 2007/02/14 18:20:17 dirtyepic Exp $

WX_GTK_VER="2.6"

inherit eutils autotools wxwidgets flag-o-matic

DESCRIPTION="FFT-based realtime audio spectral manipulation and display"
HOMEPAGE="http://freqtweak.sourceforge.net"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

DEPEND=">=x11-libs/wxGTK-2.6
	>=sci-libs/fftw-3.0
	=dev-libs/libsigc++-1.2*
	dev-libs/libxml2
	media-sound/jack-audio-connection-kit"

S="${WORKDIR}/${PN}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	eautoreconf
}

src_compile() {
	need-wxwidgets gtk2 || die "No gtk2 version of x11-libs/wxGTK found"

	append-flags "-fno-strict-aliasing"

	econf || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS ChangeLog NEWS README THANKS
}
