# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/sooperlooper/sooperlooper-1.6.5.ebuild,v 1.1 2008/07/11 16:13:27 aballier Exp $

EAPI=1

inherit wxwidgets eutils autotools

DESCRIPTION="Live looping sampler with immediate loop recording"
HOMEPAGE="http://essej.net/sooperlooper/index.html"
SRC_URI="http://essej.net/sooperlooper/${P}.tar.gz
	mirror://gentoo/${P}-m4.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="media-sound/jack-audio-connection-kit
	x11-libs/wxGTK:2.8
	media-libs/liblo
	dev-libs/libsigc++:1.2
	media-libs/libsndfile
	media-libs/libsamplerate
	dev-libs/libxml2
	media-libs/rubberband
	sci-libs/fftw:3.0"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_unpack() {
	unpack ${A}
	epatch "${FILESDIR}/${P}-cxxflags.patch"
	epatch "${FILESDIR}/${P}-asneeded.patch"
	cd "${S}"
	epatch "${FILESDIR}/${P}-rubberband12.patch"
	AT_M4DIR="${WORKDIR}/aclocal" eautoreconf
}

src_compile() {
	WX_GTK_VER="2.8"
	need-wxwidgets unicode
	econf --disable-optimize --with-wxconfig-path="${WX_CONFIG}"
	emake || die "emake failed."
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
	dodoc OSC README
}
