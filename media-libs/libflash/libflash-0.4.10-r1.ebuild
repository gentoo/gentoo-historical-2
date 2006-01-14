# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libflash/libflash-0.4.10-r1.ebuild,v 1.16 2006/01/14 04:13:15 halcy0n Exp $

inherit eutils

DESCRIPTION="A library for flash animations"
HOMEPAGE="http://www.swift-tools.com/Flash/"
SRC_URI="http://www.directfb.org/download/contrib/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc sparc alpha amd64"
IUSE=""

DEPEND="media-libs/jpeg
	sys-libs/zlib"

src_unpack() {
	unpack ${A} ; cd "${S}"

	# patch to fix the sqrt not defined problem in gcc3.1
	# It should be ok with gcc2.95 thanks to Doug Goldstein 
	# <dougg@ufl.edu> (Cardoe)
	epatch "${FILESDIR}"/${P}-sqrt.patch
	epatch "${FILESDIR}"/${P}-gcc41.patch
}

src_install() {
	make DESTDIR="${D}" install || die "Install failed"
	dodoc AUTHORS COPYING README
}
