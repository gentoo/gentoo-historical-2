# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/dos2unix/dos2unix-3.1.ebuild,v 1.1 2002/12/01 05:54:20 vapier Exp $

DESCRIPTION="Dos2unix converts DOS or MAC text files to UNIX format"
HOMEPAGE=""
SRC_URI="http://www2.tripleg.net.au/dos2unix.builder/${P}.tar.bz2"

LICENSE="freedist"
SLOT="0"
KEYWORDS="x86"

DEPEND=""
RDEPEND=""

src_unpack() {
	unpack ${A}
	cd ${S}
	patch -p1 < ${FILESDIR}/${P}.patch || die
	patch -p1 < ${FILESDIR}/${P}-segfault.patch || die
}

src_compile() {
	make clean || die
	make CFLAGS="${CFLAGS}" || die
}

src_install() {
	dobin dos2unix
	dosym dos2unix /usr/bin/mac2unix

	doman dos2unix.1
	dosym dos2unix.1.gz /usr/share/man/man1/mac2unix.1.gz
}
