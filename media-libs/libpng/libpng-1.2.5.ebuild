# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libpng/libpng-1.2.5.ebuild,v 1.3 2002/11/14 09:43:44 seemant Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Portable Network Graphics library"
SRC_URI="ftp://swrinde.nde.swri.edu/pub/png/src/${P}.tar.gz"
HOMEPAGE="http://www.libpng.org/"

SLOT="1.2"
LICENSE="as-is"
KEYWORDS="~x86 ~ppc ~sparc ~sparc64 ~alpha"

DEPEND="sys-libs/zlib"

src_compile() {
	sed -e "s:ZLIBLIB=.*:ZLIBLIB=/usr/lib:" \
		-e "s:ZLIBINC=.*:ZLIBINC=/usr/include:" \
		-e "s/-O3/${CFLAGS}/" \
		-e "s:prefix=/usr/local:prefix=/usr:" \
			scripts/makefile.linux > Makefile

	einfo "${LDFLAGS}"
	emake || die
}

src_install() {
	dodir /usr/{include,lib}
	dodir /usr/share/man
	make \
		DESTDIR=${D} \
		MANPATH=/usr/share/man \
		install || die
	
#	rm ${D}/usr/lib/libpng.so
#	rm ${D}/usr/lib/libpng.a
#	rm ${D}/usr/include/png.h
#	rm ${D}/usr/include/pngconf.h
	
	doman *.[35]
	dodoc ANNOUNCE CHANGES KNOWNBUG LICENSE README TODO Y2KINFO
}

pkg_postinst() {
	# the libpng authors really screwed around between 1.2.1 and 1.2.3
	[ -f /usr/lib/libpng.so.3.1.2.1 ] && rm /usr/lib/libpng.so.3.1.2.1
}
