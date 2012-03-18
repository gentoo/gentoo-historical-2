# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/delay/delay-1.6.ebuild,v 1.25 2012/03/18 19:11:17 armin76 Exp $

inherit toolchain-funcs

DESCRIPTION="Sleeplike program that counts down the number of seconds specified"
HOMEPAGE="http://onegeek.org/~tom/software/delay/"
SRC_URI="http://onegeek.org/~tom/software/delay/dl/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~mips ppc ppc64 x86 ~amd64-linux ~ia64-linux ~x86-linux ~ppc-macos"
IUSE=""

src_compile() {
	sed -i -e "s/#include <stdio.h>/&\n#include <stdlib.h>/" delay.c
	tc-export CC
	econf
	emake || die
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc ChangeLog README || die
}
