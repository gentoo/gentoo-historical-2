# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/wscr/wscr-1.2.ebuild,v 1.6 2004/07/01 12:11:19 eradicator Exp $

DESCRIPTION="A Lightweight and Fast Anagram Solver"
HOMEPAGE="http://hood.sjfn.nb.ca/~eddie/wscr.html"
SRC_URI="ftp://hood.sjfn.nb.ca/pub/eddie/${P}.tar.gz"
LICENSE="public-domain"
SLOT="0"

KEYWORDS="x86 alpha ~sparc ~mips"
IUSE=""
DEPEND="virtual/libc
	>=sys-apps/sed-4"
RDEPEND="virtual/libc
	sys-apps/miscfiles"

src_compile() {
	sed -i 's#"/usr/dict/words";#"/usr/share/dict/words";#' wscr.h
	sed -i 's#\($(CC) $(FLAGS)\)#\1 ${CFLAGS}#g' Makefile
	emake || die
}

src_install() {
	exeinto /usr/bin
	doexe wscr
	doman wscr.6
	dodoc README
}
