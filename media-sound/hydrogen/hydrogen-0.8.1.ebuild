# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/hydrogen/hydrogen-0.8.1.ebuild,v 1.5 2004/06/25 00:05:33 agriffis Exp $


DESCRIPTION="Linux Drum Machine"
HOMEPAGE="http://hydrogen.sourceforge.net"
SRC_URI="mirror://sourceforge/hydrogen/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86"

IUSE="alsa jack"

DEPEND="virtual/x11
	>=media-libs/audiofile-0.2.3 \
	alsa? ( media-libs/alsa-lib ) \
	jack? ( media-sound/jack-audio-connection-kit ) \
	>=x11-libs/qt-3"

src_compile() {
	addwrite ${QTDIR}/etc/settings
	econf || die
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc AUTHORS BUGS ChangeLog FAQ README TODO
}
