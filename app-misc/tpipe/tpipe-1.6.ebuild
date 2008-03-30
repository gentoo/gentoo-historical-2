# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/tpipe/tpipe-1.6.ebuild,v 1.3 2008/03/30 13:20:00 coldwind Exp $

inherit toolchain-funcs

DESCRIPTION="Command to duplicate standard input to more than one program"
HOMEPAGE="http://www.eurogaran.com/downloads/tpipe"
SRC_URI="http://www.eurogaran.com/downloads/tpipe/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""
DEPEND="virtual/libc"

src_compile() {
	emake OPTFLAGS="-ansi -pedantic ${CFLAGS}" PREFIX=/usr CC="$(tc-getCC)" LDFLAGS="${LDFLAGS}"
}

src_install() {
	dobin tpipe
	doman tpipe.1
	dodoc README
}
