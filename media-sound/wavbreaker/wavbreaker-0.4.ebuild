# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/wavbreaker/wavbreaker-0.4.ebuild,v 1.7 2004/07/19 22:59:51 eradicator Exp $

IUSE=""

inherit eutils

DESCRIPTION="wavbreaker/wavmerge GTK2 utility to break or merge WAV file"
HOMEPAGE="http://huli.org/wavbreaker/"
SRC_URI="http://huli.org/wavbreaker/${P}.tar.gz"
#-sparc, -amd64: 0.4: wavinfo pop.wav gives bogus information... probably sizeof() and endian related...
KEYWORDS="x86 -sparc -amd64"
SLOT="0"
LICENSE="GPL-2"

DEPEND="dev-libs/libxml2
	>=x11-libs/gtk+-2.0
	virtual/libc"

DOCS="ChangeLog COPYING INSTALL README NEWS"

src_unpack() {
	unpack ${A}
	epatch ${FILESDIR}/${P}-gcc2_fix.patch
}

src_install() {
	make DESTDIR=${D} install
	dodoc ${DOCS}
}
