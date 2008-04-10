# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/ams/ams-1.8.8_rc2.ebuild,v 1.2 2008/04/10 12:14:58 drac Exp $

inherit eutils qt3

DESCRIPTION="Alsa Modular Software Synthesizer"
HOMEPAGE="http://alsamodular.sourceforge.net"
SRC_URI="mirror://sourceforge/alsamodular/${P/_/-}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~x86"
IUSE=""

RDEPEND="media-libs/alsa-lib
	 media-sound/jack-audio-connection-kit
	 =x11-libs/qt-3*
	 =sci-libs/fftw-2*
	 media-libs/ladspa-sdk
	 media-libs/ladspa-cmt
	 media-plugins/mcp-plugins
	 media-plugins/swh-plugins
	 media-libs/libclalsadrv"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${P/_/-}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-spectrumscreen.patch
}

src_compile() {
	eqmake3
	emake || die "emake failed."
}

src_install() {
	dobin ${PN}
	dodoc README THANKS
	insinto /usr/share/${PN}
	doins -r demos instruments tutorial *.mid
}

pkg_postinst() {
	elog "Upstream HOMEPAGE also suggests following packaged to be installed:"
	elog "- media-plugins/amb-plugins"
	elog "- media-plugins/rev-plugins"
	elog "- media-plugins/vco-plugins"
}
