# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/beep/beep-1.2.2.ebuild,v 1.14 2004/06/28 03:25:56 vapier Exp $

DESCRIPTION="the advanced PC speaker beeper"
HOMEPAGE="http://www.johnath.com/beep/"
SRC_URI="http://www.johnath.com/beep/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc alpha amd64"
IUSE=""

DEPEND="virtual/libc"

src_compile() {
	emake || die "compile problem"
}

src_install() {
	dodir /usr/bin
	dodir /usr/share/man/man1

	exeinto /usr/bin
	doexe beep
	chmod 4755 ${D}/usr/bin/beep

	insinto /usr/share/man/man1
	doins beep.1.gz

	dodoc CHANGELOG CREDITS README
}
