# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/shapelib/shapelib-1.2.10.ebuild,v 1.4 2004/06/24 23:33:25 agriffis Exp $

inherit base eutils

DESCRIPTION="ShapeLib"
HOMEPAGE="http://gdal.velocet.ca/projects/shapelib/"
SRC_URI="ftp://gdal.velocet.ca/pub/outgoing//${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE=""

DEPEND="virtual/glibc"

src_compile() {
	pmake || die
	make lib || die
}

src_install() {
	into /usr
	exeinto /usr/bin
	doexe shpcreate
	doexe shpdump
	doexe shptest
	doexe shpadd
	doexe dbfcreate
	doexe dbfdump
	doexe dbfadd
	dolib.so .libs/libshp.so.1.0.1
	dosym libshp.so.1.0.1 usr/lib/libshp.so
	insinto /usr/include/libshp
	doins shapefil.h
}
