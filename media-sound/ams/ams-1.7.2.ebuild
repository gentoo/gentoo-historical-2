# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/ams/ams-1.7.2.ebuild,v 1.4 2004/04/24 12:38:59 kugelfang Exp $

DESCRIPTION="Alsa Modular Software Synthesizer"
HOMEPAGE="http://alsamodular.sourceforge.net"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~amd64"
IUSE=""

RDEPEND=" >=media-libs/alsa-lib-0.9
	virtual/jack
	>=x11-libs/qt-3.0.0
	>=dev-libs/fftw-2*
	media-libs/ladspa-sdk"

DEPEND="${RDEPEND}
	sys-apps/sed"


SRC_URI="http://alsamodular.sourceforge.net/${P}.tar.bz2"

src_unpack() {
	unpack ${A} || die
	cd ${S}

	sed -i "s%QT_BASE_DIR=/usr/lib/qt3%QT_BASE_DIR=/usr/qt/3%" Makefile
}

src_compile() {
	make || die "Make failed."
}

src_install() {
	dobin ams

	dodoc README INSTALL THANKS LICENSE

	docinto examples
	dodoc *.ams
}
