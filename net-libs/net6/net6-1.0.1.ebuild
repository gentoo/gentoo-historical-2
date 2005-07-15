# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/net6/net6-1.0.1.ebuild,v 1.3 2005/07/15 16:17:03 humpback Exp $

DESCRIPTION="Network access framework for IPv4/IPv6 written in C++"
HOMEPAGE="http://darcs.0x539.de/net6"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~ppc ~x86 ~amd64"
IUSE=""
SRC_URI="http://releases.0x539.de/${PN}/${P}.tar.gz"

DEPEND=">=dev-libs/libsigc++-2.0"

src_compile() {
	econf || die "./configure failed"
	emake || die "make failed"
}

src_install() {
	make DESTDIR=${D} install || die
}

