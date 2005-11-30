# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/id3tool/id3tool-1.2.ebuild,v 1.1 2003/02/27 18:30:41 mkennedy Exp $

DESCRIPTION="A command line utility for easy manipulation of the ID3 tags present in MPEG Layer 3 audio files"
HOMEPAGE="http://nekohako.xware.cx/id3tool/"
SRC_URI="http://nekohako.xware.cx/id3tool/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""
DEPEND=""

S=${WORKDIR}/${P}

src_compile() {
	econf
	emake || die
}

src_install() {
	einstall
	dodoc CHANGELOG COPYING README 
}
