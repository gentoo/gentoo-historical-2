# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/net6/net6-1.2.2-r1.ebuild,v 1.1 2006/10/14 13:20:50 humpback Exp $

DESCRIPTION="Network access framework for IPv4/IPv6 written in c++"
HOMEPAGE="http://darcs.0x539.de/net6"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""
SRC_URI="http://releases.0x539.de/${PN}/${P}.tar.gz"

DEPEND=">=dev-libs/libsigc++-2.0
		>=dev-util/pkgconfig-0.20"

src_compile() {
	econf || die "./configure failed"
	emake || die "make failed"
}

src_install() {
	make DESTDIR=${D} install || die
}
