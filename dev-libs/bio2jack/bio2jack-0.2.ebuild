# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/bio2jack/bio2jack-0.2.ebuild,v 1.1 2004/08/26 00:50:01 pkdawson Exp $

DESCRIPTION="A library for porting blocked I/O OSS/ALSA audio applications to JACK."
HOMEPAGE="http://bio2jack.sourceforge.net/"
SRC_URI="mirror://sourceforge/bio2jack/${P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~x86"
IUSE=""
DEPEND=">=media-sound/jack-audio-connection-kit-0.80.0"

S=${WORKDIR}/${PN}

src_install() {
	make DESTDIR=${D} install || die
	dodoc AUTHORS ChangeLog INSTALL NEWS README
}
