# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/m2vrequantizer/m2vrequantizer-20030925.ebuild,v 1.1 2007/01/15 16:10:11 hd_brummy Exp $

MY_P="${PN/m2vr/M2VR}-${PV}"

DESCRIPTION="Tool to requantize mpeg2 videos"
HOMEPAGE="http://www.metakine.com/products/dvdremaster/modules.html"
SRC_URI="mirror://vdrfiles/requant/${MY_P}.tar.bz2"

KEYWORDS="~x86 ~amd64"
SLOT="0"
LICENSE="GPL-2"
IUSE=""

DEPEND=""

S=${WORKDIR}/${MY_P}/src

src_compile() {

	gcc -c ${CFLAGS} main.c -o requant.o
	gcc ${CFLAGS} requant.o -o requant -lm
}

src_install() {

	dobin requant
}

