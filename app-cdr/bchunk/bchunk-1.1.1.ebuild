# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-cdr/bchunk/bchunk-1.1.1.ebuild,v 1.17 2004/10/05 21:08:41 malc Exp $

inherit gcc

DESCRIPTION="Converts bin/cue CD-images to iso+wav/cdr"
HOMEPAGE="http://hes.iki.fi/bchunk/"
SRC_URI="http://hes.iki.fi/bchunk/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc sparc ~amd64"
IUSE=""

DEPEND="virtual/libc"

src_compile() {
	$(gcc-getCC) ${CFLAGS} -o bchunk bchunk.c || die
}

src_install() {
	dobin bchunk || die
	doman bchunk.1
	dodoc ${P}.lsm README
}
