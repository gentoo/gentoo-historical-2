# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/cli-crypt/cli-crypt-1.0.ebuild,v 1.11 2004/06/24 21:30:57 agriffis Exp $

inherit gcc

DESCRIPTION="Command-line interface to crypt(3)"
HOMEPAGE="http://freshmeat.net/projects/cli-crypt/"
SRC_URI="http://www.xjack.org/downloads/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc sparc"
IUSE=""

DEPEND="virtual/glibc"

src_compile() {
	emake CC="$(gcc-getCC)" CFLAGS="${CFLAGS} -lcrypt" || die
}

src_install() {
	dobin crypt || die
}
