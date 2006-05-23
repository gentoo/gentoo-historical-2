# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/fapg/fapg-0.30.ebuild,v 1.5 2006/05/23 19:53:23 corsair Exp $

IUSE=""

inherit toolchain-funcs

DESCRIPTION="Fast Audio Playlist Generator"
HOMEPAGE="http://royale.zerezo.com/fapg/"
SRC_URI="http://royale.zerezo.com/fapg/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 sparc x86"

src_compile() {
	echo "$(tc-getCC) ${CFLAGS} ${LDFLAGS} -o fapg fapg.c"
	$(tc-getCC) ${CFLAGS} ${LDFLAGS} -o fapg fapg.c || die "build failed"
}

src_install() {
	dobin fapg
	dodoc CHANGELOG README
	doman fapg.1
}
