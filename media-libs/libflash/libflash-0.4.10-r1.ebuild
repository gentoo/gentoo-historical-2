# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libflash/libflash-0.4.10-r1.ebuild,v 1.9 2003/08/31 10:34:53 plasmaroo Exp $

S=${WORKDIR}/${P}
DESCRIPTION="A library for flash animations"
SRC_URI="http://www.directfb.org/download/contrib/${P}.tar.gz"
HOMEPAGE="http://www.swift-tools.com/Flash/"

DEPEND="media-libs/jpeg
	sys-libs/zlib"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ppc sparc ~alpha"

src_unpack() {

	unpack ${P}.tar.gz

	# patch to fix the sqrt not defined problem in gcc3.1
	# It should be ok with gcc2.95 thanks to Doug Goldstein 
	# <dougg@ufl.edu> (Cardoe)
	patch -p0 < ${FILESDIR}/${P}-sqrt.patch || die

}

src_compile() {

	econf || die "Configure failed"
	emake || die "Make failed"

}

src_install () {

	make DESTDIR=${D} install || die "Install failed"
	dodoc AUTHORS COPYING README

}
