# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/jpeg/jpeg-6b-r2.ebuild,v 1.8 2002/10/04 05:47:59 vapier Exp $

MY_P=${PN}src.v${PV}
S=${WORKDIR}/${P}
DESCRIPTION="Library to load, handle and manipulate images in the JPEG format"
SRC_URI="ftp://ftp.uu.net/graphics/jpeg/${MY_P}.tar.gz"
HOMEPAGE="http://www.ijg.org/"

SLOT="0"
LICENSE="as-is"
KEYWORDS="x86 ppc sparc sparc64 alpha"

DEPEND="virtual/glibc"

src_compile() {

	econf \
		--enable-shared \
		--enable-static || die

	make || die
}

src_install() {

	dodir /usr/{include,lib,bin,share/man/man1}
	make \
		prefix=${D}/usr \
		mandir=${D}/usr/share/man/man1 \
		install || die

	dodoc README change.log structure.doc
}
