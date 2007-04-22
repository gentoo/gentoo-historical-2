# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/ipx-utils/ipx-utils-1.1-r2.ebuild,v 1.3 2007/04/22 16:11:20 phreak Exp $

inherit eutils

DESCRIPTION="The IPX Utilities"
HOMEPAGE="ftp://sunsite.unc.edu/pub/Linux/system/filesystems/ncpfs/"
SRC_URI="ftp://sunsite.unc.edu/pub/Linux/system/filesystems/ncpfs/${P/-utils}.tar.gz"

LICENSE="Caldera"
SLOT="0"
KEYWORDS="~amd64 ppc64 s390 sparc x86"
IUSE=""

DEPEND="virtual/libc"

S=${WORKDIR}/${P/-utils}

src_unpack() {
	unpack ${A}

	sed -i "s:-O2 -Wall:${CFLAGS}:" "${S}"/Makefile
	epatch "${FILESDIR}"/${P}-makefile.patch
	epatch "${FILESDIR}"/${P}-proc.patch #67642
}

src_install() {
	dodir /sbin /usr/share/man/man8
	dodoc "${S}"/README
	make DESTDIR="${D}" install || die "make install failed!"

	newconfd "${FILESDIR}"/ipx.confd ipx
	newinitd "${FILESDIR}"/ipx.init ipx
}
