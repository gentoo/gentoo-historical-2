# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/libast/libast-0.4-r1.ebuild,v 1.8 2002/12/09 04:41:48 manson Exp $

S=${WORKDIR}/${P}
DESCRIPTION="LIBrary of Assorted Spiffy Things.  Needed for Eterm."
SRC_URI="http://www.eterm.org/download/${P}.tar.gz"
HOMEPAGE="http://www.eterm.org/download"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc sparc "

DEPEND="virtual/glibc
		virtual/x11
		>=media-libs/freetype-1.3"

src_compile() {
	# always disable mmx because binutils-2.11.92+ seems to be broken for this package
	myconf="--disable-mmx"
	./configure \
		--host=${CHOST} \
		--prefix=/usr \
		--infodir=/usr/share/info \
		--mandir=/usr/share/man "${myconf}" || die "./configure failed"
	emake || die
}

src_install () {
	make DESTDIR=${D} install || die
	dodoc README
}
