# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/qjackconnect/qjackconnect-0.0.3b-r1.ebuild,v 1.8 2004/06/13 08:32:23 eradicator Exp $

DESCRIPTION="A QT based patchbay for the JACK Audio Connection Kit"
HOMEPAGE="http://www.suse.de/~mana/jack.html"
SRC_URI="ftp://ftp.suse.com/pub/people/mana/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~amd64"
IUSE=""
DEPEND="virtual/glibc
	>=x11-libs/qt-3.0.5
	media-sound/jack-audio-connection-kit"

src_unpack() {
	unpack ${A}
	cd ${S}
	sed \
		-e "s:/usr/lib/qt3:/usr/qt/3:" \
		-e "s:-O2 -g:${CXXFLAGS}:" \
		< make_qjackconnect > Makefile
}

src_compile() {
	make || die
}

src_install() {
	dobin qjackconnect
}
