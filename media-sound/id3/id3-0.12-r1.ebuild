# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/id3/id3-0.12-r1.ebuild,v 1.16 2004/09/29 03:33:52 tgall Exp $

IUSE=""

DESCRIPTION="changes the id3 tag in an mp3 file"
HOMEPAGE="http://lly.org/~rcw/abcde/page/"
SRC_URI="http://lly.org/~rcw/id3/${PN}_${PV}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc amd64 sparc ~ppc64"

src_compile() {
	make CFLAGS="${CFLAGS}" || die
}

src_install() {
	make install DESTDIR=${D} || die
	dodoc README
}
