# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Maintainer: Desktop Team <desktop@gentoo.org>
# Author: Achim Gottinger <achim@gentoo.org>, Daniel Robbins <drobbins@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/media-libs/libpng/libpng-1.2.3.ebuild,v 1.1 2002/05/26 11:20:19 seemant Exp $

S=${WORKDIR}/${P}
DESCRIPTION="libpng"
SRC_URI="ftp://swrinde.nde.swri.edu/pub/png/src/${P}.tar.gz"
HOMEPAGE="http://www.libpng.org/"
SLOT="1.2"
DEPEND=">=sys-libs/zlib-1.1.4"

src_compile() {
	sed -e "s:ZLIBLIB=../zlib:ZLIBLIB=/usr/lib:" \
		-e "s:ZLIBINC=../zlib:ZLIBINC=/usr/include:" \
		-e "s/-O3/${CFLAGS}/" \
		-e "s:prefix=/usr/local:prefix=/usr:" \
			scripts/makefile.linux > Makefile

	emake || die
}

src_install() {
	dodir /usr/{include,lib}
	dodir /usr/share/man
	make \
		DESTDIR=${D} \
		MANPATH=/usr/share/man \
		install || die

	doman *.[35]
	dodoc ANNOUNCE CHANGES KNOWNBUG LICENSE README TODO Y2KINFO
}
