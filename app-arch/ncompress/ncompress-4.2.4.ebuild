# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/ncompress/ncompress-4.2.4.ebuild,v 1.23 2004/04/27 03:03:09 lv Exp $

DESCRIPTION="Another uncompressor for compatibility"
SRC_URI="ftp://ftp.leo.org/pub/comp/os/unix/linux/sunsite/utils/compress/${P}.tar.gz"
HOMEPAGE="ftp://ftp.leo.org/pub/comp/os/unix/linux/sunsite/utils/compress/"

SLOT="0"
LICENSE="public-domain"
KEYWORDS="amd64 x86 ppc sparc alpha mips hppa ia64 ppc64 s390"

src_unpack() {
	unpack ${A}
	cd ${S} ; epatch ${FILESDIR}/ncompress-gcc34.patch
}

src_compile() {
	sed -e "s:options= :options= ${CFLAGS} :" \
		-e "s:CC=cc:CC=${CC:-gcc}:" Makefile.def > Makefile
	make || die
}

src_install() {
	dobin compress
	dosym compress /usr/bin/uncompress
	doman compress.1
}
