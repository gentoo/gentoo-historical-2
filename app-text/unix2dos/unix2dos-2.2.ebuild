# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/unix2dos/unix2dos-2.2.ebuild,v 1.14 2004/06/28 04:14:12 ciaranm Exp $

inherit gcc eutils

DESCRIPTION="UNIX to DOS text file format converter"
HOMEPAGE=""
SRC_URI="mirror://gentoo/${P}.src.tar.gz"

LICENSE="freedist"
SLOT="0"
KEYWORDS="x86 ppc alpha amd64 sparc hppa ~mips"

DEPEND=""
RDEPEND=""

S=${WORKDIR}

src_unpack() {
	unpack ${A}
	epatch ${FILESDIR}/${PN}-mkstemp.patch
	epatch ${FILESDIR}/${P}-segfault.patch
	epatch ${FILESDIR}/${P}-manpage.patch
}

src_compile() {
	$(gcc-getCC) ${CFLAGS} -o unix2dos unix2dos.c || die
}

src_install() {
	dobin unix2dos || die
	doman unix2dos.1
}
