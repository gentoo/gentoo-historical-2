# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/quicktime4linux/quicktime4linux-1.5.5-r1.ebuild,v 1.7 2003/02/13 12:54:18 vapier Exp $

S=${WORKDIR}/quicktime
DESCRIPTION="quicktime library for linux"
SRC_URI="http://heroinewarrior.com/${P}.tar.gz"
HOMEPAGE="http://heroinewarrior.com/quicktime.php3"

SLOT="0"
LICENSE="LGPL-2.1"
KEYWORDS="x86 sparc  ppc"

DEPEND="media-libs/jpeg
	media-libs/libpng"

PROVIDE="virtual/quicktime"

src_unpack() {
	unpack ${P}.tar.gz

	cd ${S}
	patch -p1 < ${FILESDIR}/quicktime_makefile.patch
}

src_compile() {
	
	emake || die
	make util || die
}

src_install () {

	dolib.so `uname -m`/libquicktime.so
	dolib.a  `uname -m`/libquicktime.a
	insinto /usr/include/quicktime
	doins *.h
	dodoc README 
	dohtml -r docs
}
